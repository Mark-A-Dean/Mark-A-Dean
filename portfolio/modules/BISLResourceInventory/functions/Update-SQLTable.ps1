using namespace Microsoft.SqlServer.Management.Smo;
using namespace System.Data;
using namespace System.Data.SqlClient;

function Update-SQLTable
{
    <#
        .Synopsis
            Sends a System.Data.Datatable object to a SQL base table.
        .DESCRIPTION
            A DataTable object is passed into a SQL Stored Procedure and mapped
             to a User-Defined Table Type parameter.
            Table Type.
        .EXAMPLE
           Update-SQLTable MyServer,MyDatabase,Dflt.MySproc,$dtVar;
        .INPUTS
            [String] ServerName
            [String] DatabaseName
            [String] Schema.StoredProcedure
            [DataTable] DataTable
        .NOTES
            Prexisting SQL objects required:
                User-Defined Table Type (UDTT).
                Base Table.
                Stored Procedure with UDTT parameter.
        .NOTES
            Pass parameter values as a DataTable object.
            Objects are Reference variables in PowerShell by default.
        .COMPONENT
            BISLResourceInventory module
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $ServerName,

        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DatabaseName,

        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                HelpMessage="SchemaName.ProcedureName",
                Position=2)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^\w+\.\w+$")]
        [string] $StoredProcedure,

        [Parameter(Mandatory=$true,
            HelpMessage="Object must reference a DataTable object.",
            Position=3)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.Data.DataTable] $DataTable
    )
    Begin
    {
        [void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");
    }
    Process
    {
        [Server]$server = $ServerName;
        [Database]$database = $server.Databases.Item($DatabaseName);

        $targetConnection = [SQLConnection]::new("Server=$($server.Name); Database=$($database.Name); Integrated Security=true");
            $targetConnection.Open();
                $manageTargetTable = [SqlCommand]::new("$($StoredProcedure)",$targetConnection);
                $manageTargetTable.CommandType = [CommandType]::StoredProcedure;
                $manageTargetTable.Parameters.Add([SqlParameter]::new("@dt",[SQLDbType].Structured)).Value = $DataTable;
                [void]$manageTargetTable.ExecuteNonQuery();
            $targetConnection.Close();
    }
}
