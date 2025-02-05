function Update-BaseTable {
    <#
    .Synopsis
        Extracts text from html files, converts them to data objects, and 
        stores them in a SQL Server database data table.
    .DESCRIPTION
        Extracts text from html files, converts them to data objects, and 
        stores them in a SQL Server database data table.
    .EXAMPLE
        Update-BaseTable -ServerName $SqlServerName`
        -DatabaseName $SqlDatabaseName -StoredProcedure "Dflt.MyProcedure"`
        -DataTable $MyDataCollection;
    .INPUTS
        [String]
        [System.Data.DataTable]
    .OUTPUTS
        [System.Data.DataTable]
    .COMPONENT
        FileDetails
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,Position=0)] #[ValidatePattern("^\w+?\.something\.something$")]
        [string] $ServerName,
        [Parameter(Mandatory=$true,Position=1)] [string] $DatabaseName,
        [Parameter(Mandatory=$true,Position=2)] [string] $StoredProcedure,
        [Parameter(Mandatory=$false,Position=3)] [System.Data.DataTable] $DataTable
    )
    Begin {
        Add-Type -AssemblyName System.Windows.Forms;
        [void][reflection.assembly]::LoadWithPartialName('Microsoft.SqlServer.Smo');
    }
    Process {
        [Microsoft.SqlServer.Management.Smo.Server]$server = $ServerName;
        [Microsoft.SqlServer.Management.Smo.Database]$database = $server.Databases.Item($DatabaseName);
        $targetConnection = [System.Data.SqlClient.SQLConnection]::new("Server=$($server.Name); Database=$($database.Name); Integrated Security=true");
        $targetConnection.Open();
            $manageTargetTable = [System.Data.SqlClient.SqlCommand]::new("$($StoredProcedure)",$targetConnection);
            $manageTargetTable.CommandType = [System.Data.CommandType]::StoredProcedure;
            if($DataTable.Rows.Count -ne 0){
                try{
                    $manageTargetTable.Parameters.Add([System.Data.SqlClient.SqlParameter]::new("@dt",[System.Data.SqlDbType].Structured)).Value = $DataTable;
                    [void]$manageTargetTable.ExecuteNonQuery();
                }
                catch{
                    $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
                    $_errorMsg=[string]::Format("Exception: Update-BaseTable($($StoredProcedure))`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
                    $_errorBoxTitle="Exception in base table data loading."
                    $_errorButtonType=[System.Windows.Forms.MessageBoxButtons]::OK;
                    $_errorButtonIcon=[System.Windows.Forms.MessageBoxIcon]::Stop;
                    [System.Windows.Forms.MessageBox]::Show($_errorMsg,$_errorBoxTitle,$_errorButtonType,$_errorButtonIcon);
                    return;
                }
            }
            else{
                try{
                    $tsqlQuery = [string]::Format("EXECUTE {0};",$StoredProcedure);
                    [void]$database.ExecuteNonQuery($tsqlQuery);
                }
                catch{
                    $_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
                    $_errorMsg=[string]::Format("Exception: Update-BaseTable($($StoredProcedure)): No parameter option.`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
                    $_errorBoxTitle="Exception in base table data loading."
                    $_errorButtonType=[System.Windows.Forms.MessageBoxButtons]::OK;
                    $_errorButtonIcon=[System.Windows.Forms.MessageBoxIcon]::Stop;
                    [System.Windows.Forms.MessageBox]::Show($_errorMsg,$_errorBoxTitle,$_errorButtonType,$_errorButtonIcon);
                    return;
                }
            }
        $targetConnection.Close();
    }
}
