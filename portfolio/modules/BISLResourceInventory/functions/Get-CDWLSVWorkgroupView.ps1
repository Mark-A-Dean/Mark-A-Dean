using module BISLResourceInventory;
function Get-CDWLSVWorkgroupView
{
    <#
    .Synopsis
        Gets system metadata and aggregations from SQL Views in the LSV databases on one or more SQL Server instance.
    .DESCRIPTION
        Gets system metadata and aggregations from SQL Views in the LSV databases on one or more SQL Server instance.
        These views are limited by the database schemas in which they are located.
        The data are stored in an Inventory database that is managed by a SQL stored procedure.
    .EXAMPLE
        Get-CDWLSVWorkgroupView
    .EXAMPLE
        Get-CDWLSVWorkgroupView -ShowExceptionLog
    .INPUTS
        Test-ServerConnection
    .COMPONENT
        Get-CDWResourceInventory
    #>
    [CmdletBinding()]
    Param()
    Begin
    {
        [void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");
    }
    Process
    {
        $fxnExceptionLog = "C:\Program Files\WindowsPowerShell\Modules\BISLResourceInventory\errors\Get-CDWLSVWorkgroupView\$((Get-Date).ToString("s").Replace(':','_')).log";
        $baseTableExceptionLog = "C:\Program Files\WindowsPowerShell\Modules\BISLResourceInventory\errors\Get-CDWLSVWorkgroupView\$("BaseTable_"+(Get-Date).ToString("s").Replace(':','_')).log";

        $CDWWorkgroupViews = [System.Data.DataTable]::new('CDWLSVWorkgroupView','Inventory')
            [void]$CDWWorkgroupViews.Columns.Add("CreateDate",[datetime]);
            [void]$CDWWorkgroupViews.Columns.Add("CriticalColumnCount",[int]);
            [void]$CDWWorkgroupViews.Columns.Add("CriticalColumns",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("DateLastModified",[datetime]);
            [void]$CDWWorkgroupViews.Columns.Add("HasAfterTrigger",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasDataSetFilter",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasDeleteTrigger",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasExtendedProperties",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasFullTextIndex",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasIndex",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasInsertTrigger",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasInsteadOfTrigger",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasPAIDBool",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasPHIPIIBool",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasSDataExpression",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("HasUpdateTrigger",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("ID",[int]);
            [void]$CDWWorkgroupViews.Columns.Add("IsDeveloperSecured",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("IsEncrypted",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("IsIndexable",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("IsSchemaBound",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("Name",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("NbrColumns",[int]);
            [void]$CDWWorkgroupViews.Columns.Add("Owner",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("ParentGuid",[guid]);
            [void]$CDWWorkgroupViews.Columns.Add("ParentName",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("ReturnsViewMetadata",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("SchemaName",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("ServerName",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("State",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("TextMode",[bool]);
            [void]$CDWWorkgroupViews.Columns.Add("Urn",[string]);
            [void]$CDWWorkgroupViews.Columns.Add("HashID",[string]);

            function Add-CDWLSVWorkgroupView([CDWLSVWorkgroupView]$data)
            {
                Process
                {
                    $row = $CDWWorkgroupViews.NewRow();
                        $row.CreateDate = $data.CreateDate;
                        $row.CriticalColumnCount = $data.CriticalColumnCount;
                        $row.CriticalColumns = $data.CriticalColumns;
                        $row.DateLastModified = $data.DateLastModified;
                        $row.HasAfterTrigger = $data.HasAfterTrigger;
                        $row.HasDataSetFilter = $data.HasDataSetFilter;
                        $row.HasDeleteTrigger = $data.HasDeleteTrigger;
                        $row.HasExtendedProperties = $data.HasExtendedProperties;
                        $row.HasFullTextIndex = $data.HasFullTextIndex;
                        $row.HasIndex = $data.HasIndex;
                        $row.HasInsertTrigger = $data.HasInsertTrigger;
                        $row.HasInsteadOfTrigger = $data.HasInsteadOfTrigger;
                        $row.HasPAIDBool = $data.HasPAIDBool;
                        $row.HasPHIPIIBool = $data.HasPHIPIIBool;
                        $row.HasSDataExpression = $data.HasSDataExpression;
                        $row.HasUpdateTrigger = $data.HasUpdateTrigger;
                        $row.ID = $data.ID;
                        $row.IsDeveloperSecured = $data.IsDeveloperSecured;
                        $row.IsEncrypted = $data.IsEncrypted;
                        $row.IsIndexable = $data.IsIndexable;
                        $row.IsSchemaBound = $data.IsSchemaBound;
                        $row.Name = $data.Name;
                        $row.NbrColumns = $data.NbrColumns;
                        $row.Owner = $data.Owner;
                        $row.ParentGuid = $data.ParentGuid;
                        $row.ParentName = $data.ParentName;
                        $row.ReturnsViewMetadata = $data.ReturnsViewMetadata;
                        $row.SchemaName = $data.SchemaName;
                        $row.ServerName = $data.ServerName;
                        $row.State = $data.State;
                        $row.TextMode = $data.TextMode;
                        $row.HashID = $data.HashID;
                        $row.Urn = $data.Urn;
                    $CDWWorkgroupViews.Rows.Add($row);
                }
            }
        [Microsoft.SqlServer.Management.Smo.Server]$dniServer = "MySourceServer";
        [Microsoft.SqlServer.Management.Smo.Database]$dniDatabase = $dniServer.Databases.Item("MySourceDatabase");

        $dniSchema = [System.Collections.Generic.List[string]]::new();

        $getDNISchemasQuery = 'SELECT * FROM Sys.schemas WHERE schema_id < 16380 ORDER BY name';
        $dniDatabase.ExecuteWithResults($getDNISchemasQuery).Tables[0].name|&{
            Process
            {
                [void]$dniSchema.Add($_);
            }
        }

        $getServerSet = Test-CDWServerConnection DB;

        foreach($svr in ($getServerSet[0]).Where({$_.IsConnected -eq $true}))
        {
            # try/catch --not included in this code version
            [Microsoft.SqlServer.Management.Smo.Server]$sourceServer = $svr.ServerName;
            if($sourceServer.Status -eq "Online")
            {
                [Microsoft.SqlServer.Management.Smo.Database]$sourceDatabase = $sourceServer.Databases.Item("LSV");
                $sourceDatabase.Views.Where({$_.Schema -notin $dniSchema})|&{
                    Process
                    {
                        $lsvView = [CDWLSVWorkgroupView]::new($PSItem);
                        Add-CDWLSVWorkgroupView($lsvView);
                    }
                }
            }
        }

        if($CDWWorkgroupViews.Rows.Count -gt 0)
        {
            try
            {
                [Microsoft.SqlServer.Management.Smo.Server]$targetServer = "MyTargetServer";
                [Microsoft.SqlServer.Management.Smo.Database]$targetDatabase = $targetServer.Databases.Item("MyTargetDatabase");

                Update-SQLTable -ServerName $targetServer.Name -DatabaseName $targetDatabase.Name -StoredProcedure "Inventory.ManageCDWLSVWorkgroupView" -DataTable $CDWWorkgroupViews;
                $targetDatabase.ExecuteNonQuery("EXEC Dflt.SetExtendedProperties_L1 'Inventory','CDWLSVWorkgroupView','U';");
            }
            catch
            {
                "## Base table update"+"`r`n"+$PSItem.Exception *>> $baseTableExceptionLog;
            }
        }
    }
}