# About Table-Valued Parameters

The BISL Resource Inventory Program 2.0 (from here on, *Inventory*) makes use of **table-valued parameters** (TVP) to transfer .NET DataTable objects into SQL base tables by way of SQL stored procedures. TVPs were introduced in SQL Server 2008 to provide a means to handle arrays, an object type which SQL Server does not support. Other than lacking JDBC drivers and backwards compatibilty for legacy code, TVPs replace the commonplace list-of-values approach in SQL Server. SQL stored procedures and queries use this parameter as a table variable and may include utilizing set-based operations. This provides a performance gain over the separate executions for each parameter value supplied in the list-of-values approach.

## Benefits

Table-valued parameters offer more flexibility and in some cases better performance than temporary tables or other ways to pass a list of parameters. TVPs offer the following benefits:

1. Do not acquire locks for the initial population of data from a client.
1. Provide a simple programming model.
1. Enable you to include complex business logic in a single routine.
1. Reduce round trips to the server.
1. Can have a table structure of different cardinality.
1. Are strongly typed.
1. Enable the client to specify sort order and unique keys.
1. Are cached like a temp table when used in a stored procedure.
1. Starting with SQL Server 2012 (11.x), table-valued parameters are also cached for parameterized queries.

A TVP is created and used in Inventory as such:

1. A User-Defined Table Type is created on the target SQL database.
   1. This type may or may not have a primary key defined.
2. A PowerShell populates the parameter with a DataTable object using `System.Data.SQLClient` objects.
3. A SQL stored procedure calls this typed object to execute `INSERT`, `UPDATE`, and `DELETE` statements on the base table.

## Remarks

As demands increase on the Inventory loads, and as the SQL Server environments change, the `DataTable` object will be phased out of existing code in preference for streaming operatrions.  It is planned that all new developments will have this streaming feature.

## Code

In the example below, the TVP is identified as the SQL variable `dt`. It is populated with data from the DataTable object, `CDWFileShares`. The SQL stored procedure, `Inventory.ManageCDWFileShare` executes using this object as its parameter.

### PowerShell

``` PowerShell
        if($CDWFileShares.Rows.Count -gt 0)
        {
            [Server]$targetServer = "MyServer";
            [Database]$targetDatabase = $targetServer.Databases.Item("CDW_Internals");

            $targetConnection = [SQLConnection]::new("Server=$($targetServer.Name); Database=$($targetDatabase.Name); Integrated Security=true");
            $targetConnection.Open();
                $manageTargetTable = [SQLCommand]::new("Inventory.ManageCDWFileShare",$targetConnection);
                $manageTargetTable.CommandType = [CommandType]::StoredProcedure;
                $manageTargetTable.Parameters.Add([SqlParameter]::new("@dt",[SQLDbType].Structured)).Value = $CDWFileShares;
                [void]$manageTargetTable.ExecuteNonQuery();
            $targetConnection.Close();
        }
```

### SQL

![Inventory.ManageCDWFileShare](../images/screenshot_ManageCDWFileShare.jpg)

## Measure

![Inventory.ManageCDWWorkgroupMember](../images/screenshot_MeasureCommand.jpg)

## References

+ "**an object type which SQL Server does not support**": Sarka, Dejan, Miloš Radivojević, and William Durkin. *SQL Server 2017 Developer's Guide*. Birmingham, England. Packt Publishing Ltd., 2018.
+ "**Table-valued parameters offer more flexibility and in some cases better performance than temporary tables**": "Use Table-Valued Parameters (Database Engine): Benefits". docs.microsoft.com/en-us/sql/relational-databases/tables/use-table-valued-parameters-database-engine?view=sql-server-ver15#Benefits. Accessed 2021-07-01.
