CREATE PROCEDURE Inventory.ManageAuditLog
    @dt Inventory.DT_AuditLog READONLY
AS
OnUpdate:
	UPDATE tt
	SET
	tt.Auditor=st.Auditor,
	tt.CreationTimeUtc=st.CreationTimeUtc,
    tt.Description=st.Description,
	tt.DirectoryName=st.DirectoryName,
    tt.EventDate=st.EventDate,
    tt.EventName=st.EventName,
    tt.EventState=st.EventState,
    tt.FullName=st.FullName,
    tt.HashID=st.HashID,
	tt.LastAccessTimeUtc=st.LastAccessTimeUtc,
	tt.LastWriteTimeUtc=st.LastWriteTimeUtc,
    tt.Manifest=st.Manifest,
	tt.Parent=st.Parent,
	tt.RowModifiedDateTime=SYSUTCDATETIME()
	FROM Inventory.AuditLog As tt
	INNER JOIN @dt As st
	ON st.HashID=tt.HashID
OnInsert:
	INSERT INTO Inventory.AuditLog(Auditor,CreationTimeUtc,Description,DirectoryName,EventDate,EventName,EventState,FullName,HashID,LastAccessTimeUtc,LastWriteTimeUtc,Manifest,Parent)
	SELECT st.Auditor,st.CreationTimeUtc,st.Description,st.DirectoryName,
    st.EventDate,st.EventName,st.EventState,st.FullName,st.HashID,
    st.LastAccessTimeUtc,st.LastWriteTimeUtc,st.Manifest,st.Parent
    FROM @dt As st
	LEFT OUTER JOIN Inventory.AuditLog As tt
	ON tt.FullName=st.FullName
	WHERE tt.FullName IS NULL;
	
	EXECUTE Dflt.SetExtendedProperties_L1 'Inventory','AuditLog','U';
	EXECUTE Dflt.SetExtendedProperties_L1 'Report','vw_AuditLog','V';
	EXECUTE Dflt.SetExtendedProperties_L1 'Report','vw_AuditLogManifest','V';
RETURN 0
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-01-13T16:49",
    "Description": "Manages data in the Inventory.AuditLog table.",
    "Replaces": "2.0.0",
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "PROCEDURE",
    "Title": "MyDatabase.Inventory.ManageAuditLog",
    "Version": "2.5.0",
    "Parameters":[
        {"Name":"@dt","Description":"READONLY table-valued parameter of the Graph.DT_AuditLog type."}
	]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageAuditLog'
GO
