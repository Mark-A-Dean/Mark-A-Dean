CREATE VIEW [Report].[vw_AuditLogManifest] As
SELECT a._id,a.Auditor,a.Description,
a.EventDate,a.EventName,a.EventState,b.*,
a.Parent+'\'+b.Manifest_FileName As AuditFileFullName
FROM Inventory.AuditLog As a
CROSS APPLY OPENJSON(a.Manifest)
WITH(
	[Manifest_FileName] varchar(128) '$.file_name',
	[Manifest_DataDisposition] varchar(7) '$.data_disposition',
	[Manifest_Comment] varchar(140) '$.comment'
) As b;
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-01-15T20:19:43",
    "Description": "Returns elements from Inventory.AuditLog and the expansion of the Manifest JSON value.",
    "Replaces": "Inventory.vw_AuditLogManifest",
    "Identifier": "MyDatabase.Report",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "VIEW",
    "Title": "MyDatabase.Report.vw_AuditLogManifest",
    "Version": "1.5.0",
    "Columns":[
        {"Name":"_id","Description":"Primary key. Identity value on the table row."},
		    {"Name":"Auditor","Description":"Use the Active Directory account furnished by the VA."},
		    {"Name":"Description","Description":"The action type of the manifest."},
		    {"Name":"EventDate","Description":"The date when the audit was performed that created the manifest."},
		    {"Name":"EventName","Description":"The name of the audit type that created the manifest.."},
		    {"Name":"EventState","Description":"The state of the audit; pre-approval,approved,hold,rejected."},
		    {"Name":"Manifest_FileName","Description":"Name of the individual file included in the manifest."},
		    {"Name":"Manifest_DataDisposition","Description":"The type of data disposition desired for the individual file included in the manifest."},
		    {"Name":"Manifest_Comment","Description":"A comment for the individual file included in the manifest."},
		    {"Name":"AuditFileFullName","Description":"The concatenation of the parent file directory and the individual manifest file name."},
	]
}' , @level0type=N'SCHEMA',@level0name=N'Report', @level1type=N'VIEW',@level1name=N'vw_AuditLogManifest'
GO
