# Update-BaseTable

**Applies to**: :heavy_check_mark: SQL Server

NameSpace: FileDetails  
Module: FileDetails.psm1  

A PowerShell cmdlet that executes a Transact-SQL stored procedure over a SQL Server connection. The declared TSQL data objects must be valid and the executor must have the required permissions to execute the command on the SQL database. 

> This cmdlet, when in the **FileDetails** namespace, is intended to only be called and executed automatically by [Get-FileDetails](./get-filedetails.md) or iterative cmdlets.

## Syntax

PowerShell
***
``` powershell
Update-BaseTable  
    -ServerName <string>  
    -DatabaseName <string>  
    -StoredProcedure <string>  
    -DataTable <[System.Data.DataTable]>
```

## Description

The cmdlet uses the parameter values to establish a SQL Server connection to a database that hosts the named procedure. It then executes the named procedure, which requires the datatable object as its own [User-Defined Table Type](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-type-transact-sql?view=sql-server-ver16#c-creating-a-user-defined-table-type) parameter.

## Permissions
Executors must be members of the SQL Database role **db_owner** or **db_ddladmin** either individually or by membership in a shared database principal.

## Examples

### Example 1: Execute a Transact-SQL stored procedure.
The following example contains PowerShell variables (ex. `$SqlServerName`) and a simple string to pass values into the cmdlet. The cmdlet then executes the declared stored procedure over the SQL Server connection, which processes the data inside the datatable object.

PowerShell
***
``` powershell
# 
Update-BaseTable -ServerName $SqlServerName -DatabaseName $SqlDatabaseName -StoredProcedure "Inventory.ManageFileDetails" -DataTable $FileCollection;
```

## Parameters

### SqlServerName  

The fully qualified domain name of a SQL Server Instance. The ValidatePattern parameter option may be enabled to check that the supplied FQDN matches.

|||
|:--|:--|
|Type|String|
|Position|1|
|Default value|Provided by cmdlet variable.|
|Required|True|
|Pattern validated|True|

### SqlDatabaseName  
The name of the SQL database hosted on **SqlServerName** that stores a base table associated with an object in the [DataTable Class](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-9.0).

|||
|:--|:--|
|Type|String|
|Position|2|
|Default value|Provided by cmdlet variable.|
|Required|True|

### StoredProcedure
The name of the SQL stored procedure hosted on **SqlDatabaseName**. It should have a single table-valued parameter[^1] that accepts a .NET datatable object.

|||
|:--|:--|
|Type|String|
|Position|3|
|Default value|Provided by cmdlet string value.|
|Required|True|

### DataTable

|||
|:--|:--|
|Type|String|
|Position|4|
|Default value|Provided by cmdlet variable.|
|Required|True|

## Outputs

**System.Windows.Forms**

Popup windows contain messages whenever an error exception is encountered.

## See also

- [Get-AuditLog](./get-auditlog.md)
- [Get-FileDetails](./get-filedetails.md)
  
## References
[^1]: [Use table-valued parameters (Database Engine)](https://learn.microsoft.com/en-us/sql/relational-databases/tables/use-table-valued-parameters-database-engine?view=sql-server-ver16)
