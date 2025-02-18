CREATE TABLE Inventory.FileDetailsRoot(
	_id int identity primary key,
	RootPath	varchar(256),
	RootDirectoryName	varchar(128),
	SubdirectoryQuery	varchar(256),
	RowModifiedDateTime	datetime2(0) DEFAULT SYSUTCDATETIME()
)

DECLARE @dateIssued varchar(20) = (SELECT FORMAT(SYSUTCDATETIME(),'yyyy-MM-ddTHH:mm:ss'));
DECLARE @jDesc varchar(4000) = N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "'+@dateIssued+'",
    "Description": "Stores data related to the inventory cycle entry point (i.e., the root).",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "TABLE",
    "Title": "MyDatabase.Inventory.FileDetailsRoot",
    "Version": "1.0.0",
    "Columns":[
        {"Name":"_id","Description":"Primary key. Identity value on the table row."},
		{"Name":"RootPath","Description":"The URI of the file directory supplied as the AncestorPath parameter value in the Get-FileDetails cmdlet."},
		{"Name":"RootDirectoryName","Description":"Name of the directory serving as the root."},
		{"Name":"SubdirectoryQuery","Description":"A regex expression that provides the type and levels of recursion to the Get-FileDetails cmdlet."},
		{"Name":"RowModifiedDateTime","Description":"Date and time when the row was last modified."}
	]
}'
EXEC sys.sp_addextendedproperty	@name=N'Header', 
	@value=@jDesc,
	@level0type=N'SCHEMA', 
	@level0name=N'Inventory', 
	@level1type=N'TABLE', 
	@level1name=N'FileDetailsRoot'
GO