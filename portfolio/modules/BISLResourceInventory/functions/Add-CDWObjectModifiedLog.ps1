function Add-CDWObjectModifiedLog
{
    <#
        .Synopsis
            Creates one or more entries in the Inventory.CDWObjectModifiedLog table.
        .DESCRIPTION
            Creates one or more entries in the Inventory.CDWObjectModifiedLog table.
        .EXAMPLE
            Add-CDWObjectModifiedLog;
        .NOTES
            Execute this function as the last step in the Get-CDWResourceInventory workflow
             to prevent bad table entries. Use Remove-CDWObjectModifiedLog to delete bad entries.
        .COMPONENT
            BISLResourceInventory module
    #>
    [CmdletBinding()]
    Param
    ()
    Process
    {
        $fxnExceptionLog = "C:\Program Files\WindowsPowerShell\Modules\BISLResourceInventory\errors\Add-CDWObjectModifiedLog\$((Get-Date).ToString("s").Replace(':','_')).log";
        try
        {
            [Server]$targetServer = "VHACDWA01";
            [Database]$targetDatabase = $targetServer.Databases.Item("CDW_Internals");
            $targetDatabase.ExecuteNonQuery('Execute Inventory.AddCDWObjectModifiedLog;');
        }
        catch
        {
            $PSItem.Exception.Message *>> $fxnExceptionLog;
        }
    }
}