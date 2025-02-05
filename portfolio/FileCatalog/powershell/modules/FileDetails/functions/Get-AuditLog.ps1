function Get-AuditLog{
    <#
    .Synopsis
    .EXAMPLE
        The following example uses parameter splatting.
        $x=@{
            AncestorPath="\\myFileShare\MyDirectory\";
            Subdirectory=".*?";
            SqlServerName="MySqlServerInstance";
            SqlDatabaseName="MyDatabaseName";
        }
        Get-AuditLog @x;
    .INPUTS
        File system files.
    .OUTPUTS
        [System.Data.DataTable]
        [System.Windows.Forms]
    .NOTES
    .COMPONENT
        FileDetails
    .FUNCTIONALITY
        Data collection and management.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
            Position=0,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Literal path to a file directory locations.")]
        [ValidateScript(
            {
                if(!($_ |Test-Path -PathType Container)){
                    throw "File directory does not exist.";
                }
                return $true;
            }
        )]
        [System.IO.FileInfo] $AncestorPath,
        [Parameter(Mandatory=$true,
            Position=1,
            HelpMessage="Name of a subdirectory. May include regular
                expressions for fuzzy searches.")]
        [string] $Subdirectory,
        
        [Parameter(Mandatory=$true,
            Position=2,
            HelpMessage="FQDN of a SQL Server Instance.")
        ]
        #[ValidatePattern("^\w+?\.something\.something$")]
        [string]$SqlServerName,
        
        [Parameter(
            Mandatory=$true,
            Position=3,
            HelpMessage="SQL database name where a base table is stored."
        )
        ]
        [string]$SqlDatabaseName
    )
    begin{
        [void][reflection.assembly]::LoadWithPartialName(
            'Microsoft.SqlServer.Smo'
        );
        Add-Type -AssemblyName System.Windows.Forms;
    }  
    process {
        try {
            $noError=$true;
#region classes;
            Class AuditLog{
                [string] $Auditor;
                [datetime] $CreationTimeUtc;
                [string] $Description;
                [string] $DirectoryName;
                [string] $EventDate;
                [string] $EventName;
                [string] $EventState;
                [string] $FullName;
                [string] $HashID;
                [datetime] $LastAccessTimeUtc;
                [datetime] $LastWriteTimeUtc;
                [string] $Manifest;
                [string] $DirectoryPath;
                AuditLog($p1){
                    $this.Auditor=$p1.Content.auditor;
                    $this.CreationTimeUtc=$p1.CreationTimeUtc;
                    $this.Description=$p1.Content.description;
                    $this.DirectoryName=$p1.DirectoryName;
                    $this.EventDate=$p1.Content.event_date;
                    $this.EventName=$p1.Content.event_name;
                    $this.EventState=$p1.Content.event_state;
                    $this.FullName=$p1.FullName;
                    $this.HashID=New-HashID($p1.FullName,$p1.CreationTimeUtc,$p1.LastAccessTimeUtc,$p1.LastWriteTimeUtc -join'^');
                    $this.LastAccessTimeUtc=$p1.LastAccessTimeUtc;
                    $this.LastWriteTimeUtc=$p1.LastWriteTimeUtc;
                    $this.Manifest=$this.ConvertManifest($p1.Content.manifest);
                    $this.DirectoryPath=($p1.Content.directory_path).Replace('/','\');
                }
                [string]ConvertManifest($q1){
                    return $q1|ConvertTo-Json -Compress;
                }
                Add($q1){
                    Add-AuditLog $q1;
                }
            }
#endregion;
#region datatable objects;
            $AuditLogCollection=[System.Data.DataTable]::new();
                [void]$AuditLogCollection.Columns.Add("Auditor",[string]);
                [void]$AuditLogCollection.Columns.Add("CreationTimeUtc",[datetime]);
                [void]$AuditLogCollection.Columns.Add("Description",[string]);
                [void]$AuditLogCollection.Columns.Add("DirectoryName",[string]);
                [void]$AuditLogCollection.Columns.Add("EventDate",[string]);
                [void]$AuditLogCollection.Columns.Add("EventName",[string]);
                [void]$AuditLogCollection.Columns.Add("EventState",[string]);
                [void]$AuditLogCollection.Columns.Add("FullName",[string]);
                [void]$AuditLogCollection.Columns.Add("HashID",[string]);
                [void]$AuditLogCollection.Columns.Add("LastAccessTimeUtc",[datetime]);
                [void]$AuditLogCollection.Columns.Add("LastWriteTimeUtc",[datetime]);
                [void]$AuditLogCollection.Columns.Add("Manifest",[string]);
                [void]$AuditLogCollection.Columns.Add("DirectoryPath",[string]);
#endregion;
#region internal functions;
            function Add-AuditLog([AuditLog]$data){
                process{
                    $row=$AuditLogCollection.NewRow();
                        $row.Auditor=$data.Auditor;
                        $row.CreationTimeUtc=$data.CreationTimeUtc;
                        $row.Description=$data.Description;
                        $row.DirectoryName=$data.DirectoryName;
                        $row.EventDate=$data.EventDate;
                        $row.EventName=$data.EventName;
                        $row.EventState=$data.EventState;
                        $row.FullName=$data.FullName;
                        $row.HashID=$data.HashID;
                        $row.LastAccessTimeUtc=$data.LastAccessTimeUtc;
                        $row.LastWriteTimeUtc=$data.LastWriteTimeUtc;
                        $row.Manifest=$data.Manifest;
                        $row.DirectoryPath=$data.DirectoryPath;
                    $AuditLogCollection.Rows.Add($row);
                }
            }
#endregion;
#region data;
            try{
                $_dirCollection=(Get-ChildItem $AncestorPath -Directory).Where({
                    $_.PSIsContainer -and $_.Name -match $Subdirectory;
                })|Select-Object -ExpandProperty FullName;
            }
            catch{
                $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
                $_errorMsg=[string]::Format("Exception: Directory collection loading`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
                $_errorLog=@("Get-AuditLog",$_errorMsg);
                New-ExceptionWindow -ErrorLog $_errorLog;
                return;
            }
            :getEachAncestor1 foreach($i in $_dirCollection){
                try{
                    :getEachAuditLog foreach($j in (Get-ChildItem $i -Recurse)){
                        $j=$j|Select-Object -Property Attributes,CreationTimeUtc,DirectoryName,Extension,FullName,LastAccessTimeUtc,LastWriteTimeUtc,Name;
                        if($j.Attributes -notmatch "Directory" -and $j.Name -eq "audit.log"){
                            $x=Get-Item $j.FullName|Select-Object -Property `
                            @{
                                l="Content";
                                e={
                                    Get-Content $j.FullName|ConvertFrom-Json;
                                }
                            },
                            CreationTimeUtc,
                            DirectoryName,
                            FullName,
                            LastAccessTimeUtc,
                            LastWriteTimeUtc
                            $result=[AuditLog]::new($x);
                            $result.Add($result);
                        }
                    }
                }
                catch{
                    $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
                    $_errorMsg=[string]::Format("Exception in getting file data`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
                    $_errorLog=@("Get-AuditLog",$_errorMsg);
                    New-ExceptionWindow -ErrorLog $_errorLog;
                    return;
                }
            }
#endregion;
#region sql;
            Update-BaseTable -ServerName $SqlServerName -DatabaseName $SqlDatabaseName -StoredProcedure "Inventory.ManageAuditLog" -DataTable $AuditLogCollection;
#endregion;
        }
        catch {
            $noError=$false;
            #$_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
            $_errorMsg=[string]::Format("Get-AuditLog encountered a system error.");
            $_errorLog=@("Get-AuditLog",$_errorMsg);
            New-ExceptionWindow -ErrorLog $_errorLog;
        }
        if($noError){
            Write-Host "`r`nGet-AuditLog has completed successfully."; # command prompt output; this statement may be deleted.
        }
    }
}
