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
ftxRebuild:
ALTER FULLTEXT INDEX ON Inventory.FileDetails
	START FULL POPULATION;
ALTER FULLTEXT INDEX ON DOEx.vw_FileDetails
	START FULL POPULATION;
MetadataTag:
	EXECUTE Dflt.SetExtendedProperties_L1 'Inventory','FileDetails','U';
	EXECUTE Dflt.SetExtendedProperties_L1 'DOEx','vw_FileDetails','V';
RETURN 0
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-01-13T16:49",
    "Description": "Manages data in the Inventory.FileDetails table.",
    "Replaces": "2.5.0",
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "PROCEDURE",
    "Title": "MyDatabase.Inventory.ManageFileDetails",
    "Version": "2.6.0",
    "Parameters":[
        {"Name":"@dt","Description":"READONLY table-valued parameter of the Inventory.DT_FileDetails type."}
    ]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageFileDetails'
GO
