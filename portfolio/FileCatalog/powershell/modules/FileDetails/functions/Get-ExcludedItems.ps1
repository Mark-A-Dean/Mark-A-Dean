function Get-ExcludedItems{
<#
    .Synopsis
        Queries the file system for file metadata. A Subdirectory name is 
        supplied that may include regular expression patterns.
    .EXAMPLE
        The following example uses parameter splatting.
        Get-ExcludedItems -LiteralPath <filepath>;
    .EXAMPLE
        The following example saves the datatable object in a variable.
        $xclitems=Get-ExcludedItems -LiteralPath <filepath>;
    .INPUTS
        JSON file.
    .OUTPUTS
        [System.Data.DataTable]
        [System.Windows.Forms]
    .COMPONENT
        File Catalog
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
                if(!($_ |Test-Path)){
                    throw "File or directory does not exist.";
                }
                return $true;
            }
        )]
        [System.IO.FileInfo] $LiteralPath
    )
    begin{
        Add-Type -AssemblyName System.Windows.Forms;
    }
    process{
        try{
            $noError=$true;
#region classes;
            Class ExcludedItem{
                [string] $EventDate;
                [string] $EventName;
                [string] $FullName;
                [string] $Name;
                [string] $Parent;
                [string] $Root;
                [string] $Type;
                ExcludedItem($p1){
                    $this.EventDate=$p1[0];
                    $this.EventName=$p1[1];
                    $this.Name=$p1[2];
                    $this.Parent=$p1[3];
                    $this.Root=$p1[4];
                    $this.Type=$p1[5];        
                    $this.FullName=$p1[4],$p1[2]-join'\';
                }
                Add($q1){
                    Add-ExcludedItem $q1;
                }
            }
#endregion;
#region datatables objects;
            $ExcludedItemCollection=[System.Data.DataTable]::new();
                [void]$ExcludedItemCollection.Columns.Add("EventDate",[string]);
                [void]$ExcludedItemCollection.Columns.Add("EventName",[string]);
                [void]$ExcludedItemCollection.Columns.Add("FullName",[string]);
                [void]$ExcludedItemCollection.Columns.Add("Name",[string]);
                [void]$ExcludedItemCollection.Columns.Add("Parent",[string]);
                [void]$ExcludedItemCollection.Columns.Add("Root",[string]);
                [void]$ExcludedItemCollection.Columns.Add("Type",[string]);
                #$ExcludedItemCollection.PrimaryKey=$ExcludedItemCollection.Columns["FullName"];
#endregion;
#region internal functions;
            function Add-ExcludedItem([ExcludedItem]$data){
                process{
                    $row=$ExcludedItemCollection.NewRow();
                        $row.EventDate=$data.EventDate;
                        $row.EventName=$data.EventName;
                        $row.FullName=$data.FullName;
                        $row.Name=$data.Name;
                        $row.Parent=$data.Parent;
                        $row.Root=$data.Root;
                        $row.Type=$data.Type;
                    $ExcludedItemCollection.Rows.Add($row);
                }
            }
#endregion;
#region etl;
            # JSON validation is not provided. Check wrapper function when referenced by another cmdlet.
            $jsonDoc=Get-Content($LiteralPath)|ConvertFrom-Json;
            [array]$_parentCollection=($jsonDoc.PSObject.Properties).Where({ $_.Value -is [array]}).Name;
            for($i=0; $i -lt $_parentCollection.Count; $i++){
                foreach($j in $jsonDoc."$($_parentCollection[$i])"){
                    [string]$parent=$_parentCollection[$i];
                    foreach($k in $j.manifest){
                        [array]$x=@($j.event_date,$j.event_name,$k.name,$parent,$j.Root,$k."@type");
                        $results=[ExcludedItem]::new($x);
                        $results.Add($results);
                    }
                }
            }
#endregion;
#region return;
            return $ExcludedItemCollection;
#endregion;
        }
        catch {
            $noError=$false;
            $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
            $_errorMsg=[string]::Format("Get-ExcludedItems encountered a system error at `r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
            $_errorLog=@("Get-FileDetails",$_errorMsg);
            New-ExceptionWindow -ErrorLog $_errorLog;
            return;
        }
        if($noError){
            Write-Host "Get-ExcludedItems has completed successfully."; # commandline output; this statement may be deleted.
        }
    }
}
