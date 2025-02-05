# DOEx.vw_FileDetails (Transact-SQL)

**Applies to**: :heavy_check_mark: SQL Server

Returns a row for each file processed during an inventory cycle.

|Column name|Data type|Description|
|:--|:--|:--|
||||
|\_id|int|Row identity value.|
|Ancestor1|varchar(256)|The recognized first tier of the file directory system hierarchy. Might not be the highest directory in a path.|
|AssignmentPriority|char(1)|A simplified ranking determined by combinations of AuditRank ranges and the active status of a file.|
|AuditRank|int|An integer value determined by the relationships of datetime elements, the active status, file extension type, and the detectable presence of a file owner.|
|BaseName|varchar(255)|The file name without the extension or URI elements.|
|CreationTimeUtc|datetime2(0)|The date and time when the file was created.|
|DirectoryName|varchar(500)|The full URI to the immediate directory of the file.|
|Extension|varchar(20)|The suffix that appears at the end of a file name to indicate the file type.|
|FullName|varchar(500)|Primary key. The full URI of the file.|
|IsActive|bit|A Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date.|
|LastAccessTimeUtc|datetime2(0)|The date and time in the UTC time zone when the current file was last accessed.|
|LastWriteTimeUtc|datetime2(0)|The date and time in the UTC time zone when the current file was last written to.|
|Owner|varchar(60)|The user who has full control over the file.|
|Parent|varchar(128)|The recognized tier of the file directory system hierarchy immediate to a file.|
|RowModifiedDateTime|datetime2(0)|Date and time when the row was last modified.|
|Length|int|The size of current file in kilobytes.|

## Permissions

The visibility of some data sets is limited to securables that a user either owns, or on which the user was granted some permission.

## Remarks

### View type: indexed

**DOEx.vw_FileDetails** is a schema-bound database view that carries a clustered index on the `_id` column. SQL Server has supported [indexed view matching](https://learn.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-table?view=sql-server-ver16#using-noexpand) since SQL 2019; therefore, the `NOEXPAND` query hint does not need to be specified for the SQL Engine to use the view's index. Practitioners should check the query execution plan to ensure that the view's index is being utilized on more complex queries.

The view is sourced to the [Inventory.FileDetails](https://github.com/Mark-A-Dean/Mark-A-Dean/blob/main/portfolio/FileCatalog/pages/inventory-filedetails-transact-sql.md) temporal table[^1] and does not specify a system time constraint. Therefore, only the current row versions are returned.

## Examples

### A. Get file metadata

The following example returns the first 10 rows of currently active files having the top assignment priority.

T-SQL
***

``` sql
SELECT a._id,a.Ancestor1,a.Parent,a.BaseName+Extension As [FileName],
a.IsActive,a.CreationTimeUtc,a.LastAccessTimeUtc,a.LastWriteTimeUtc
,a.DataDisposition,a.AssignmentPriority,a.AuditRank,a.Length,a.DirectoryName
FROM DOEx.vw_FileDetails As a
WHERE a.IsActive=1 AND a.AssignmentPriority='A'
ORDER BY a.FullName OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```

### B. Use full text searches

Running the following query returns results where either the `Parent` or `BaseName` column value matches a set of criteria.

🔍 The match criteria below needs to be updated to reflect the data stored in the base table.

The match criteria is:
1. "cpac" occurs with some form of the word "request" **OR**
2. "fccpac" occurs with some form of the word "forecast" **AND NOT**
3. the wildcard term "* 2011".

Omitting the final step in the match criteria returns rows that include the term _2011_. The wildcard `*` isn't necessary for these data because all values include _2011_ as a standalone word. The columns list and the `OR` operand also effect the results. Practitioners are encouraged to experiment with the match criteria as they explore the data.

T-SQL
***
``` sql
SELECT a._id,a.Ancestor1,a.Parent,a.BaseName,a.CreationTimeUtc
FROM DOEx.vw_FileDetails As a
WHERE CONTAINS(
	(a.Parent,a.BaseName),'
	cpac&FORMSOF(INFLECTIONAL,request)|
	fccpac&FORMSOF(INFLECTIONAL,forecast)&!
    "* 2011"
')
ORDER BY a.CreationTimeUtc DESC;
```
## See also
- Common types of full text queries
- [Inventory.Filedetails (Transact-SQL)](https://github.com/Mark-A-Dean/Mark-A-Dean/blob/main/portfolio/FileCatalog/pages/inventory-filedetails-transact-sql.md)

## References
[^1]: [Temporal tables](https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver16)
