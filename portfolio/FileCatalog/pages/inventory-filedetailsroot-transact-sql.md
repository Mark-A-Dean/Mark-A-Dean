# Inventory.FileDetailsRoot (Transact-SQL)

**Applies to**: :heavy_check_mark: SQL Server

Returns a row for each root directory processed during an inventory cycle.

|Column name|Data type|Description|
|:--|:--|:--|
||||
|_id|Primary key. Identity value on the table row.|
|RootPath|The URI of the file directory supplied as the AncestorPath parameter value in the Get-FileDetails cmdlet.|
|"Name":"RootDirectoryName|Name of the directory serving as the root.|
|SubdirectoryQuery|A regex expression that provides the type and levels of recursion to the Get-FileDetails cmdlet.|
|RowModifiedDateTime|Date and time when the row was last modified.|
|RowModifiedDateTime|datetime2(0)|Date and time when the row was last modified.|

## Permissions

This table is accessible only to securables that a user either owns, or on which the user was granted some permission.

## Remarks

### Usage

This table is not meant to be used for direct, ad hoc queries. The data stored in this table are exposed through TSQL views and in Power BI reports.

### Population
Table population is completed on an unscheduled basis. Data management is controlled using a stored procedure.

## See also

- [Get-FileDetails](./get-filedetails.md)
- [InventoryRootCollection Class](./filedetails.inventoryrootcollection.md)
- [Update-BaseTable](./filedetails/update-basetable.md)
