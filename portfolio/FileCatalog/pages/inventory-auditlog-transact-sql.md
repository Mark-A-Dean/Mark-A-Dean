# Inventory.AuditLog (Transact-SQL)

**Applies to**: ✔️ SQL Server

Returns a row for each audit log file processed during an inventory cycle.

|Column name|Data type|Description|
|:--|:--|:--|
||||
|_id|int|Primary key and row identity value.|
|Auditor|varchar(60)|The Active Directory account of the person who reviewed the files in the current directory.|
|CreationTimeUtc|varchar(10)|The date and time when the audit log file was created.|
|Description|varchar(500)|An account of the event taken on or in the current directory.|
|DirectoryName|varchar(500)|The full URI to the immediate directory of the audit log file.|
|EventDate|varchar(10)|The date when the event occurred in `yyyy-mm-dd` format.|
|EventName|varchar(60)|The name of the action taken: i.e., _audit_.|
|EventState|varchar(12)|The state of the audit; pre-approval, approved, hold, rejected.|
|FullName|varchar(500)|The full URI of the audit log file.|
|HashID|varchar(64)|Hexadecimal representation of the FullName, CreationTimeUtc, LastAccessTimeUtc, and LastWriteTimeUtc attributes.|
|LastAccessTimeUtc|varchar(10)|The date and time in the UTC time zone when the audit log file was last accessed.|
|LastWriteTimeUtc|varchar(10)|The date and time in the UTC time zone when the audit log file was last written to.|
|Manifest|nvarchar(4000)|The audit file contents stored in a compressed JSON format. This column carries a check constraint to ensure a valid JSON structure.|
|Parent|varchar(256)|The file directory to the path of BIO team file share. Provides identifying redundancy.|
|RowModifiedDateTime|datetime2(0)|Date and time when the row was last modified.|

## Permissions

This table is accessible only to securables that a user either owns, or on which the user was granted some permission.

### Population
This table is populated on an infrequent basis. Data management is controlled using a stored procedure.

## Examples

## A. Return a list of Audit Logs

The following query returns a set of the audit logs created to date. This listing is used to find which directories have been reviewed and what state the audit event is in.

T-SQL
***
```sql
SELECT _id,Auditor,CreationTimeUtc,Description,DirectoryName,EventDate,EventName,EventState
,FullName,LastAccessTimeUtc,LastWriteTimeUtc,Manifest,Parent,RowModifiedDateTime
FROM Inventory.AuditLog;
```

## **B. Return a list of unaudited files**

The Inventory.FileDetails table is a temporal (i.e., system-versioned) table. When queried without the `FOR SYSTEM_TIME` clause, rows only in their current status are returned. To create historical returns, like the rows current to a specific date, see [Temporal tables: Queries](https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver16#how-do-i-query-temporal-data). 

> The query below uses an `OUTER APPLY` in the same manner as a `LEFT OUTER JOIN`—in fact, it may use the same query plan. However, the APPLY operator showed to have slightly improved Query Time Stats consistently in Azure Data Studio at the time of this writing.
T-SQL
***
```sql
SELECT a._id,a.Ancestor1,a.Parent,a.BaseName+a.Extension As [FileName],a.DirectoryName,
a1.HasAuditLog,a.AssignmentPriority,a.AuditRank,a.[Owner],a.DataDisposition,
a.CreationTimeUtc,a.LastAccessTimeUtc,a.LastWriteTimeUtc
FROM Inventory.FileDetails As a
OUTER APPLY (
    SELECT b.DirectoryName,1 FROM Inventory.AuditLog As b
    WHERE b.DirectoryName=a.DirectoryName
    GROUP BY b.DirectoryName
) As a1(DirectoryName,HasAuditLog)
WHERE a.IsActive=0 AND a1.HasAuditLog IS NOT NULL
ORDER BY a.AssignmentPriority DESC,a.Parent;
```

## See also
- [AuditLog Class](./filedetails.auditlog.md)
- [Get-AuditLog](./get-auditlog.md)
- [Update-BaseTable](./update-basetable.md)
