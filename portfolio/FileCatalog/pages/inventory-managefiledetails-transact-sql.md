# Inventory.ManageFileDetails (Transact-SQL)

**Applies to**:&ensp;✔️&ensp;SQL Server&ensp;✔️&ensp;[Get-FileDetails.ps1](./get-filedetails.md)

Manages data in the [Inventory.FileDetails](./inventory-filedetails-transact-sql.md) table.

## Syntax

```sql
CREATE PROCEDURE Inventory.ManageFileDetails
    @dt Inventory.DT_FileDetails READONLY
AS
OnUpdate:
	WITH cte As(
		SELECT a.Parent,
		[Assignments]=STRING_AGG(a.AssignmentPriority,CHAR(32)) WITHIN GROUP(ORDER BY a.Parent)
		FROM @dt As a
		GROUP BY a.Parent
	)
	UPDATE tt
	SET
	tt.Ancestor1=st.Ancestor1,
	tt.AssignmentPriority=st.AssignmentPriority,
	tt.AuditRank=st.AuditRank,
	tt.BaseName=st.BaseName,
	tt.CreationTimeUtc=st.CreationTimeUtc,
	tt.DataDisposition=[Inventory].[SetDataDisposition](cte.Assignments),
	tt.DirectoryName=st.DirectoryName,
	tt.Extension=st.Extension,
    tt.FullName=st.FullName,
	tt.IsActive=st.IsActive,
	tt.LastAccessTimeUtc=st.LastAccessTimeUtc,
	tt.LastWriteTimeUtc=st.LastWriteTimeUtc,
	tt.Length=st.Length,
	tt.Owner=st.Owner,
	tt.Parent=st.Parent,
	tt.HashID=st.HashID,
	tt.RowModifiedDateTime=SYSUTCDATETIME()
	FROM Inventory.FileDetails As tt
	INNER JOIN @dt As st
	ON st.FullName=tt.FullName AND (st.HashID!=tt.HashID OR tt.HashID IS NULL)
	INNER JOIN cte ON cte.Parent=st.Parent;
OnInsert:
	WITH cte As(
		SELECT a.Parent,
		[Assignments]=STRING_AGG(a.AssignmentPriority,CHAR(32)) WITHIN GROUP(ORDER BY a.Parent)
		FROM @dt As a
		GROUP BY a.Parent
	)
	INSERT INTO Inventory.FileDetails(Ancestor1,AssignmentPriority,AuditRank,BaseName,CreationTimeUtc,DataDisposition,DirectoryName,Extension,FullName,IsActive,LastAccessTimeUtc,LastWriteTimeUtc,Length,Owner,Parent,HashID)
	SELECT st.Ancestor1,st.AssignmentPriority,st.AuditRank,st.BaseName,st.CreationTimeUtc,
	[DataDisposition]=[Inventory].[SetDataDisposition](cte.Assignments),
	st.DirectoryName,st.Extension,st.FullName,st.IsActive,st.LastAccessTimeUtc,st.LastWriteTimeUtc,st.Length,st.Owner,st.Parent,st.HashID
	FROM @dt As st
	INNER JOIN cte ON cte.Parent=st.Parent
	LEFT OUTER JOIN Inventory.FileDetails As tt
	ON tt.FullName=st.FullName
	WHERE tt.HashID IS NULL;
RETURN 0
GO
```

## Arguments

### [@dt = ] _Inventory.DT_FileDetails_ READONLY

`READONLY` table-valued parameter of the `Inventory.DT_FileDetails` type.

## Return code values

`0` (success) or `1` (failure).

## Remarks

### Use case - custom PowerShell cmdlets

This stored procedure is called from custom PowerShell cmdlets whereby its single argument is populated by a System.DataTable object.

### Scalar function

This TSQL stored procedure contains a scalar function, `Inventory.SetDataDisposition`. This object must be present in the database along with the _User-Defined Table Type_ (UDTT), `Inventory.DT_FileDetails`.

### Maintain existing Full Text indexes

Modified with the following code in the presence of a full text index on the base table and its indexed view. 

```sql
ftxRebuild:
ALTER FULLTEXT INDEX ON Inventory.FileDetails
	START FULL POPULATION;
ALTER FULLTEXT INDEX ON DOEx.vw_FileDetails
	START FULL POPULATION;
RETURN 0
GO
```

## Permissions

Members of the **db_datawriter** and **db_ddladmin** fixed database roles can execute this function.

## See also

- [Get-FileDetails](./get-filedetails.md)
- [Inventory.DT_FileDetails (Transact-SQL)](#) :hammer_and_wrench: _info page for source code not yet released._
- [Inventory.FileDetails (Transact-SQL)](./inventory-filedetails-transact-sql.md)
- [Inventory.SetDataDisposition (Transact-SQL)](#) :hammer_and_wrench: _info page for source code not yet released._
- [Update-BaseTable](./update-basetable.md)
