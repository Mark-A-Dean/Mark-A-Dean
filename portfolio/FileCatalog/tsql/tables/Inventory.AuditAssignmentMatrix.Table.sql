CREATE TABLE Inventory.AuditAssignmentMatrix(
	[_id] [int] IDENTITY(1,1) NOT NULL,
	[matrix] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DefFG]
) ON [DefFG] TEXTIMAGE_ON [DefFG]
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
	"DateIssued": "2025-02-04T21:31:56",
	"Description": "Stores JSON data that represents a matrix of audit and assignment priorities in the File Catalog project.",
	"Replaces": null,
	"Identifier": "MyDatabase.Inventory",
	"IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": TABLE",
	"Title": "MyDatabase.Inventory.AuditAssignmentMatrix",
	"Version": "1.0.0",
	"Columns":[
		"{"Name":"_id","Description":"Primary key. Identity value on the table row."},
		"{"Name":"matrix","Description":"String representation of a JSON object."}
	]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'AuditAssignmentMatrix'
GO



