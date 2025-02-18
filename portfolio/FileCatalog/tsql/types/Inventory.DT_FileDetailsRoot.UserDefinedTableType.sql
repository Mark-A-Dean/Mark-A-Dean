CREATE TYPE Inventory.DT_FileDetailsRoot AS TABLE(
	RootPath	varchar(256),
	RootDirectoryName	varchar(128),
	SubdirectoryQuery	varchar(256)
)
GO

DECLARE @dateIssued varchar(20) = (SELECT FORMAT(SYSUTCDATETIME(),'yyyy-MM-ddTHH:mm:ss'));
DECLARE @jDesc varchar(4000) = N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "'+@dateIssued+'",
    "Description": "User-defined table type used as a stored procedure parameter to pass a System.Data.DataTable object in to a database table.",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "TYPE",
    "Title": "MyDatabase.Inventory.DT_FileDetailsRoot",
    "Version": "1.0.0",
    "Columns":[
		{"Name":"RootPath","Description":"The URI of the file directory supplied as the AncestorPath parameter value in the Get-FileDetails cmdlet."},
		{"Name":"RootDirectoryName","Description":"Name of the directory serving as the root."},
		{"Name":"SubdirectoryQuery","Description":"A regex expression that provides the type and levels of recursion to the Get-FileDetails cmdlet."}
	]
}'
EXEC sys.sp_addextendedproperty	@name=N'Header', 
	@value=@jDesc,
	@level0type=N'SCHEMA', 
	@level0name=N'Inventory', 
	@level1type=N'TYPE', 
	@level1name=N'DT_FileDetailsRoot'
GO
