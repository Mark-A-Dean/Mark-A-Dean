CREATE PROCEDURE Inventory.ManageAuditAssignmentMatrix
    @dt Inventory.DT_AuditAssignmentMatrix READONLY
AS
Main:
TRUNCATE TABLE Inventory.AuditAssignmentMatrix
INSERT INTO Inventory.AuditAssignmentMatrix
	SELECT jsonDoc FROM @dt;
MetadataTag:
	EXECUTE Dflt.SetExtendedProperties_L1 'Inventory','AuditAssignmentMatrix','U';
	EXECUTE Dflt.SetExtendedProperties_L1 'Report','vw_AuditAssignmentMatrix','V';
RETURN 0
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-02-04T20:18:16",
    "Description": "Manages data in the Inventory.AuditAssignmentMatrix table.",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "PROCEDURE",
    "Title": "MyDatabase.Inventory.ManageAuditAssignmentMatrix",
    "Version": "1.0.0",
    "Parameters":[
        {"Name":"@dt","Description":"READONLY table-valued parameter of the Inventory.DT_AuditAssignmentMatrix type."}
    ]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageAuditAssignmentMatrix'
GO
