# Inventory.FileDetails (Transact-SQL)

**Applies to**: ✔️ SQL Server

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
|HashID|varchar(64)|Hexadecimal representation of the FullName, AuditRank, IsActive, LastAccessTimeUtc, and LastWriteTimeUtc attributes used for internal data management operations.|
|IsActive|bit|A Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date.|
|LastAccessTimeUtc|datetime2(0)|The date and time in the UTC time zone when the current file was last accessed.|
|LastWriteTimeUtc|datetime2(0)|The date and time in the UTC time zone when the current file was last written to.|
|Length|int|The size of current file in kilobytes.|
|Owner|varchar(60)|The user who has full control over the file.|
|Parent|varchar(128)|The recognized tier of the file directory system hierarchy immediate to a file.|
|RowModifiedDateTime|datetime2(0)|Date and time when the row was last modified.|
|SysEndTime|datetime2(7)|The date and time until the row is no longer valid from a system point of view.|
|SysStartTime|datetime2(7)|The date and time since the row has been valid from a system point of view.|

## Permissions

The visibility of some data sets is limited to securables that a user either owns, or on which the user was granted some permission.

## Remarks

### Table type: temporal
**Inventory.FileDetails** is a system-versioned temporal table[^1] that stores a full history of data changes in the file metadata and auditing attributes. The SQL Server Database Engine manages the period of validity for each row.

### Population
The transactional nature of this table allows that table population is completed on an infrequent basis. Data management is controlled using a stored procedure and schema binding is enforced.

## Examples

### A. Get file data arranged by the auditing attributes

T-SQL
***
```sql
SELECT IsActive,AssignmentPriority,AuditRank,Extension,DataDisposition,Owner,
Ancestor1,BaseName,DirectoryName,CreationTimeUtc,LastAccessTimeUtc,
LastWriteTimeUtc,Length,Parent,SysEndTime,SysStartTime
FROM Inventory.FileDetails
ORDER BY IsActive,AssignmentPriority,AuditRank DESC;
```

### B. Get rows that were changed on the last inventory cycle

The following example queries the current rows (alias _a_) with a cross apply to capture all the history for the rows (alias _a1_). The results have all rows that have a difference from the current row record; this establishes a 1:M current/ historical pull.

T-SQL
***
```sql
SELECT a._id,a.IsActive,a.AssignmentPriority,a.AuditRank,a.Ancestor1,a.Parent,
a.BaseName,a.Extension,a.DataDisposition,a.Owner,a.CreationTimeUtc,a.LastAccessTimeUtc,
a.LastWriteTimeUtc,a.Length,a.SysEndTime,a.SysStartTime
FROM Inventory.FileDetails As a
CROSS APPLY(
	SELECT _id,IsActive,AssignmentPriority,AuditRank,Ancestor1,Parent,
	BaseName,Extension,DataDisposition,Owner,CreationTimeUtc,LastAccessTimeUtc,
	LastWriteTimeUtc,Length,SysEndTime,SysStartTime
	FROM Inventory.FileDetails FOR SYSTEM_TIME ALL As i
	WHERE i._id=a._id AND i.SysEndTime!=a.SysEndTime
) As a1
ORDER BY a._id;
```

## See also
- [FileCollection Class](./filedetails.filecollection.md)
- [Update-BaseTable](./update-basetable.md)

## References
[^1]: [Temporal tables](https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver16)
