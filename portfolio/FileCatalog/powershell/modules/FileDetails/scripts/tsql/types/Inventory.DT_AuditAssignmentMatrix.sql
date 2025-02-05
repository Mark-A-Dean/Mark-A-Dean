CREATE TYPE Inventory.DT_AuditAssignmentMatrix AS TABLE(
	jsonDoc nvarchar(max)
)
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-02-04T20:18:16",
    "Description": "User-defined table type used as a stored procedure parameter to pass a System.Data.DataTable object in to a database table.",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "TYPE",
    "Title": "MyDatabase.Inventory.DT_AuditAssignmentMatrix",
    "Version": "1.0.0",
    "Columns":[
		{"Name":"jsonDoc","Description":"The contents of a JSON file that must conform to the AuditAssignmentMatric JSON schema."},
	]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TYPE',@level1name=N'DT_AuditAssignmentMatrix'
GO


