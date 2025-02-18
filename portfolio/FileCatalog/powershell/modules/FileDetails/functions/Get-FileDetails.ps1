function Get-FileDetails{
    <#
        .Synopsis
            Queries the file system for file metadata. A Subdirectory name is
            supplied that may include regular expression patterns.
        .EXAMPLE
            The following example uses parameter splatting.
            $x=@{
                AncestorPath="\\myFileShare\MyDirectory\";
                Subdirectory=".*?";
                ExcludedItemsSchema="\\myFileShare\MyDirectory\json-schema-excludedItems.json";
                ExcludedItemsFile="\\myFileShare\MyDirectory\excludedItems.json";
                SqlServerName="MySqlServerInstance";
                SqlDatabaseName="MyDatabaseName";
            }
            Get-FileDetails @x;
        .INPUTS
            File system files.
        .OUTPUTS
            [System.Data.DataTable]
            [System.Windows.Forms]
        .NOTES
            Version 3.5.0
        .COMPONENT
            FileDetails.psm1
        .FUNCTIONALITY
            Data collection and management.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Literal path to file directory locations."
        )]
        [ValidateScript(
            {
                if(!($_ |Test-Path -PathType Container)){
                    throw "File directory does not exist.";
                }
                return $true;
            }
        )]
        [System.IO.FileInfo] $AncestorPath,

        [Parameter(
            Mandatory=$true,
            HelpMessage="Name of a subdirectory. May include regular expressions for fuzzy searches."
        )]
        [string] $Subdirectory,

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Literal path to a JSON schema file for excluded directories and files."
        )]
        [System.IO.FileInfo] $ExcludedItemsSchema,

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Literal path to a JSON file of excluded directories and files."
        )]
        [System.IO.FileInfo] $ExcludedItemsFile,

        [Parameter(
            Mandatory=$true,
            HelpMessage="FQDN of a SQL Server Instance.")
        ]
        #[ValidatePattern("^\w+?\.this\.this$")]
        [string]$SqlServerName,
        
        [Parameter(
            Mandatory=$true,
            HelpMessage="SQL database name where a base table is stored."
        )]
        [string]$SqlDatabaseName
    )
    begin{
        [void][reflection.assembly]::LoadWithPartialName(
            'Microsoft.SqlServer.Smo'
        );
        Add-Type -AssemblyName System.Windows.Forms;

    }
    process{
        try {
            $noError=$true;
#region classes;
            Class InventoryRoot{
                [string] $RootPath;
                [string] $RootDirectoryName;
                [string] $SubdirectoryQuery;

                InventoryRoot($p1){
                    $this.RootPath=$p1[0];;
                    $this.RootDirectoryName=$this.GetURILastPiece($p1[0]);
                    $this.SubdirectoryQuery=$p1[1];
                }
                Add($q1){
                    Add-InventoryRoot $q1;
                }
                [string]GetURILastPiece($q1){
                    $results=Get-URILastPiece $q1;
                    return $results;
                }
            }
            Class File{
                [string] hidden $_owner;
                [string] $Ancestor1;
                [string] $AssignmentPriority;
                [int] $AuditRank;
                [string] $BaseName;
                [datetime] $CreationTimeUtc;
                [string] $DirectoryName;
                [string] $Extension;
                [string] $FullName;
                [bool] $IsActive;
                [datetime] $LastAccessTimeUtc;
                [datetime] $LastWriteTimeUtc;
                [int] $Length;
                [string] $Owner;
                [string] $Parent;
                [string] $XPK;
                File($p1){
                    [datetime]$_creationTimeUtc=$p1.CreationTimeUtc;
                    [string]$_owner1=$this.GetFileOwner($p1.FullName);
                    [int]$_auditRank=$this.SetAuditRank($p1,$_owner1);
                    [bool]$_isActive=$this.SetIsActive($p1.CreationTimeUtc,$p1.LastAccessTimeUtc,$p1.LastWriteTimeUtc);
                    $this._owner=$_owner1;
                    $this.Ancestor1=$this.GetURILastPiece($p1.Ancestor1);
                    $this.AssignmentPriority=$this.SetAssignmentPriority(@($_auditRank,$_isActive));
                    $this.AuditRank=$_auditRank;
                    $this.BaseName=$p1.BaseName;
                    $this.CreationTimeUtc=$_creationTimeUtc;
                    $this.DirectoryName=$p1.DirectoryName;
                    $this.Extension=$p1.Extension;
                    $this.FullName=$p1.FullName;
                    $this.IsActive=$_isActive;
                    $this.LastAccessTimeUtc=$p1.LastAccessTimeUtc;
                    $this.LastWriteTimeUtc=$p1.LastWriteTimeUtc;
                    $this.Length=($p1.Length/1KB);
                    $this.Owner=$this._owner;
                    $this.Parent=$this.GetURILastPiece($p1.DirectoryName);
                    $this.XPK=New-HashID(($this.FullName,$_auditRank,$_isActive,$p1.LastAccessTimeUtc,$p1.LastWriteTimeUtc -join"^"));
                }
                [bool]SetIsActive($p0,$p1,$p2){
                    [datetime]$px=(Get-Date).AddYears(-3);
                    $results=switch($px){
                        {$p0 -gt $_ }{$true;break}
                        {$p1 -gt $p0 -and $p1 -gt $_}{$true;break}
                        {$p2 -gt $p0 -and $p2 -gt $_}{$true;break}
                        Default{$false}
                    }
                    return $results;
                }
                [int]SetAuditRank($p1,$p2){
                    $currentDate=Get-Date;
                    $d0=$p1.CreationTimeUtc.ToString("yyyy-MM-dd");
                    $d1=$p1.LastAccessTimeUtc.ToString("yyyy-MM-dd");
                    $d2=$p1.LastWriteTimeUtc.ToString("yyyy-MM-dd");
                    $validDate=if($p1.CreationTimeUtc -gt ($currentDate).AddYears(-5)`
                        -and $p1.CreationTimeUtc -lt $currentDate){$true}else{$false};
                    $x=switch($p1) {
                        {$validDate -eq $true}{5}
                        {$d0 -eq $d1 -and $d1 -eq $d2 -and $validDate -eq $true}{6}
                        {$d0 -eq $d1 -and $d1 -eq $d2 -and $validDate -eq $false}{11}
                        {$_.Extension -eq ".sql"}{2}
                        {$p2 -eq "No User Account Found"}{2}
                        {[string]::IsNullOrWhiteSpace($p2)}{1}
                        Default {0}
                    } 
                    return ($x|Measure-Object -Sum).Sum;
                }
                [string]SetAssignmentPriority($p1){
                    $results=switch($p1){
                        {($p1[0] -gt 8) -eq $true -and $p1[1] -eq $true}{"A";break}
                        {(5 -le $p1[0] -and $p1[0] -le 8) -eq $true -and $p1[1] -eq $true}{"B";break}
                        {($p1[0] -lt 5) -eq $true -and $p1[1] -eq $true}{"C";break}                    
                        {($p1[0] -gt 8) -eq $true -and $p1[1] -eq $false}{"D";break}
                        {(5 -le $p1[0] -and  $p1[0] -le 8) -eq $true -and $p1[1] -eq $false}{"E";break}
                        {($p1[0] -lt 5) -eq $true -and $p1[1] -eq $false}{"F";break}
                        Default{"i"}
                    }
                    return $results;
                }           
                Add($q1){
                    Add-File $q1;
                }
                [string]GetURILastPiece($q1){
                    $results=Get-URILastPiece $q1;
                    return $results;
                }
                [string]GetFileOwner($q1){
                    $x=(Get-Acl $q1).Owner;
                    if($x -match "^\w:S"){
                        return "No User Account Found";
                    }
                    else{
                        return $x;
                    }       
                }
            }
#endregion;
#region datatables objects;
            $InventoryRootCollection=[System.Data.DataTable]::new();
                [void]$InventoryRootCollection.Columns.Add("RootPath",[string]);
                [void]$InventoryRootCollection.Columns.Add("RootDirectoryName",[string]);
                [void]$InventoryRootCollection.Columns.Add("SubdirectoryQuery",[string]);

            $FileCollection=[System.Data.DataTable]::new();
                [void]$FileCollection.Columns.Add("Ancestor1",[string]);
                [void]$FileCollection.Columns.Add("AssignmentPriority",[string]);
                [void]$FileCollection.Columns.Add("AuditRank",[int]);
                [void]$FileCollection.Columns.Add("BaseName",[string]);
                [void]$FileCollection.Columns.Add("CreationTimeUtc",[datetime]);
                [void]$FileCollection.Columns.Add("DirectoryName",[string]);
                [void]$FileCollection.Columns.Add("Extension",[string]);
                [void]$FileCollection.Columns.Add("FullName",[string]);
                [void]$FileCollection.Columns.Add("IsActive",[bool]);
                [void]$FileCollection.Columns.Add("LastAccessTimeUtc",[datetime]);
                [void]$FileCollection.Columns.Add("LastWriteTimeUtc",[datetime]);
                [void]$FileCollection.Columns.Add("Length",[int]);
                [void]$FileCollection.Columns.Add("Owner",[string]);
                [void]$FileCollection.Columns.Add("Parent",[string]);
                [void]$FileCollection.Columns.Add("XPK",[string]);
#endregion;
#region internal functions;
            function Add-InventoryRoot([InventoryRoot]$data){
                process{
                    $row=$InventoryRootCollection.NewRow();
                        $row.RootPath=$data.RootPath;
                        $row.RootDirectoryName=$data.RootDirectoryName;
                        $row.SubdirectoryQuery=$data.SubdirectoryQuery;
                    $InventoryRootCollection.Rows.Add($row);
                }
            }
            function Add-File([File]$data){
                process{
                    $row=$FileCollection.NewRow();
                        $row.Ancestor1=$data.Ancestor1;
                        $row.AssignmentPriority=$data.AssignmentPriority;
                        $row.AuditRank=$data.AuditRank;
                        $row.BaseName=$data.BaseName;
                        $row.CreationTimeUtc=$data.CreationTimeUtc;
                        $row.DirectoryName=$data.DirectoryName;
                        $row.Extension=$data.Extension;
                        $row.FullName=$data.FullName;
                        $row.IsActive=$data.IsActive;
                        $row.LastAccessTimeUtc=$data.LastAccessTimeUtc;
                        $row.LastWriteTimeUtc=$data.LastWriteTimeUtc;
                        $row.Length=$data.Length;
                        $row.Owner=$data.Owner;
                        $row.Parent=$data.Parent;
                        $row.XPK=$data.XPK;
                    $FileCollection.Rows.Add($row);
                }
            }
            function Get-URILastPiece($q1){
                process{
                    $regexOptions=[Text.RegularExpressions.RegexOptions]"IgnoreCase, CultureInvariant";
                    $_uriPieceMatch="[^\\]+\\?$";
                    ([Regex]::Match($q1,$_uriPieceMatch,$regexOptions).Value).Replace("\","");
                }
            }
#endregion;
#region data;
            try{
                if($ExcludedItemsFile){
                    $_dirExclude=Get-ExcludedItems -LiteralPath $ExcludedItemsFile;
                    if($ExcludedItemsSchema -and [Regex]::Match( $PSVersionTable.PSVersion,"^7").Success -eq "True"){
                        $s1=Get-Content $ExcludedItemsSchema|ConvertTo-Json;
                        if((Test-Json $s1)){
                            if(!(Test-Json -Path $ExcludedItemsFile -SchemaFile $ExcludedItemsSchema)){
                                $_errorMsg="Exception: JSON file does not parse according to schema or there is a problem in the syntax.";
                                $_errorLog=@("Get-FileDetails: ExcludedItemsFile, ExcludedItemsSchema",$_errorMsg);
                                New-ExceptionWindow -ErrorLog $_errorLog;
                                return;
                            }
                        }
                    }
                    $_dirCollection=(Get-ChildItem $AncestorPath -Directory).Where({
                        $_ -notin $_dirExclude.FullName -and $_.PSIsContainer -and $_.Name -match $Subdirectory})|Select-Object -ExpandProperty FullName;
                }
                else{
                    $_dirCollection=(Get-ChildItem $AncestorPath -Directory).Where({$_.PSIsContainer -and $_.Name -match $Subdirectory})|Select-Object -ExpandProperty FullName;
                }
            }
            catch{
                $noError=$false;
                $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
                $_errorMsg=[string]::Format("Exception: Directory collection loading`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
                $_errorLog=@("Get-FileDetails: ExcludedItemsFile",$_errorMsg);
                New-ExceptionWindow -ErrorLog $_errorLog;
                return;
            }    
            :getEachAncestor1 foreach($i in $_dirCollection){
                :getEachFile foreach($k in Get-ChildItem $i -Recurse -ErrorAction SilentlyContinue){
                    try{
                        if($k.Attributes -notmatch "Directory"){
                            $x=$k|Select-Object -Property `
                            @{l="Ancestor1";e={$i}},
                            BaseName,
                            CreationTimeUtc,
                            DirectoryName,
                            Extension,
                            FullName,
                            LastAccessTimeUtc,
                            LastWriteTimeUtc,
                            Length;
                            $results=[File]::new($x);
                            $results.Add($results);
                        }
                    }
                    catch{
                        $noError=$false;
                        $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
                        $_errorMsg=[string]::Format("Exception in getEachFile loop.`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
                        $_errorLog=@("Get-FileDetails",$_errorMsg);
                        New-ExceptionWindow -ErrorLog $_errorLog;
                        return;
                    }
                }
            }
#endregion;
#region sql;
            Update-BaseTable -ServerName $SqlServerName -DatabaseName $SqlDatabaseName -StoredProcedure "Inventory.ManageFileDetails" -DataTable $FileCollection;
#endregion;
        }
        catch {
            $noError=$false;
            $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
            $_errorMsg=[string]::Format("Get-FileDetails encountered a system error.`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
            $_errorLog=@("Get-FileDetails",$_errorMsg);
            New-ExceptionWindow -ErrorLog $_errorLog;
        }
        if($noError){
            try{
                $newRoot=[InventoryRoot]::new(@($AncestorPath,$Subdirectory));
                $newRoot.Add($newRoot);
                Update-BaseTable -ServerName $SqlServerName -DatabaseName $SqlDatabaseName -StoredProcedure "Inventory.ManageFileDetailsRoot" -DataTable $InventoryRootCollection;
            }
            catch{
                $noError=$false;
                $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
                $_errorMsg=[string]::Format("Exception: New Root collection loading`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
                $_errorLog=@("Get-FileDetails: Upserting new root",$_errorMsg);
                New-ExceptionWindow -ErrorLog $_errorLog;
                return;
            }
            Write-Host "Get-FileDetails has completed successfully.";
            return;
        }
    }
}
