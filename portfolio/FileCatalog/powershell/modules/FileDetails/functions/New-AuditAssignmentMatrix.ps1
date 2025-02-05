function New-AuditAssignmentMatrix{
        <#
        .Synopsis
            Queries a typed JSON file for documentation.
        .EXAMPLE
            The following example uses parameter splatting.
            $x=@{
                JsonSchema="\\myFileShare\MyDirectory\excludedItems.schema.json";
                JsonFile="\\\MyDirectory\excludedItems.json";
                SqlServerName="MySqlServerInstance";
                SqlDatabaseName="MyDatabaseName";
            }
            New-AuditAssignmentMatrix @x;
        .INPUTS
            File system file.
        .OUTPUTS
            [System.Data.DataTable]
            [System.Windows.Forms]
        .NOTES
        .COMPONENT
            FileDetails
        .FUNCTIONALITY
            Documentation and information management.
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Literal path to a JSON schema file for excluded directories and files.")]
        [System.IO.FileInfo] $JsonSchema,
        
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Literal path to a JSON schema file.")]
        [System.IO.FileInfo] $JsonFile,

        [Parameter(
            Mandatory=$true,
            HelpMessage="FQDN of a SQL Server Instance.")
        ]
        #[ValidatePattern("^\w+?\.something\.something$")]
        [string]$SqlServerName,
        
        [Parameter(
            Mandatory=$true,
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
    process{
#region validation
if($JsonSchema -and [Regex]::Match( $PSVersionTable.PSVersion,"^7").Success -eq "True"){
    $s1=Get-Content $JsonSchema|ConvertTo-Json;
    if((Test-Json $s1)){
        if(!(Test-Json -Path $JsonFile -SchemaFile $JsonSchema)){
            $_errorMsg="Exception: JSON file does not parse according to schema or there is a problem in the syntax.";
            $_errorLog=@("New-AuditAssignmentMatrix",$_errorMsg);
            New-ExceptionWindow -ErrorLog $_errorLog;
            return;
        }
    }
}
#endregion;
#region datatables;
        $JsonOut=[System.Data.DataTable]::new();
            [void]$JsonOut.Columns.Add("jsonDoc",[string]);
#endregion;
#region internal functions;
            function Add-JsonDoc([string]$data){
                process{
                    $row=$JsonOut.NewRow();
                        $row.jsonDoc=$data;
                    $JsonOut.Rows.Add($row);
                }
            }
#endregion;
#region data gathering;
        try{
            $JsonDoc=Get-Content($JsonFile);
            Add-JsonDoc $JsonDoc;
        }
        catch{
            $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
            $_errorMsg=[string]::Format("Exception: Error in JSON data gathering.`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
            $_errorLog=@("New-AuditAssignmentMatrix",$_errorMsg);
            New-ExceptionWindow -ErrorLog $_errorLog;
            return;
        }
#endregion;
#region tsql;
        Update-BaseTable -ServerName $SqlServerName -DatabaseName $SqlDatabaseName -StoredProcedure "Inventory.ManageAuditAssignmentMatrix" -DataTable $JsonOut;
#endregion;
    }
}
