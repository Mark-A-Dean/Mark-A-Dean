CREATE TYPE Inventory.DT_FileDetails AS TABLE(
	[Ancestor1] [varchar](256) NULL,
	[AssignmentPriority] [char](1) NOT NULL,
	[AuditRank] [int] NOT NULL,
	[BaseName] [varchar](255) NULL,
	[CreationTimeUtc] [datetime2](0) NULL,
	[DirectoryName] [varchar](500) NULL,
	[Extension] [varchar](50) NULL,
	[FullName] [varchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[LastAccessTimeUtc] [datetime2](0) NULL,
	[LastWriteTimeUtc] [datetime2](0) NULL,
	[Length] [int] NOT NULL,
	[Owner] [varchar](60) NULL,
	[Parent] [varchar](128) NULL,
	[HashID] [varchar](64) NOT NULL
)
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2024-09-11T16:04:34",
    "Description": "User-defined table type used as a stored procedure parameter to pass a System.Data.DataTable object in to a database table.",
    "Replaces": "1.0.0",
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "TYPE",
    "Title": "MyDatabase.Inventory.DT_FileDetails",
    "Version": "1.5.0",
    "Columns":[
		  {"Name":"Ancestor1","Description":"The recognized first tier of the file directory system hierarchy. Might not be the highest directory in a path."},
		  {"Name":"AssignmentPriority","Description":"A simplified ranking determined by combinations of AuditRank ranges and the active status of a file."},
		  {"Name":"AuditRank","Description":"An integer value determined by the relationships of datetime elements, the active status, file extension type, and the detectable presence of a file owner."},
		  {"Name":"BaseName","Description":"The file name without the extension or URI elements."},
		  {"Name":"CreationTimeUtc","Description":"The date and time when the file was created."},
		  {"Name":"DirectoryName","Description":"The full URI to the immediate directory of the file."},
		  {"Name":"Extension","Description":"The suffix that appears at the end of a file name to indicate the file type."},
		  {"Name":"FullName","Description":"The full URI of the file."},
		  {"Name":"IsActive","Description":"A Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date."},
		  {"Name":"LastAccessTimeUtc","Description":"The date and time in the UTC time zone when the current file was last accessed."},
		  {"Name":"LastWriteTimeUtc","Description":"The date and time in the UTC time zone when the current file was last written to."},
		  {"Name":"Length","Description":"The file size in kilobytes."},
		  {"Name":"Owner","Description":"The user who has full control over the file."},
		  {"Name":"Parent","Description":"The recognized tier of the file directory system hierarchy immediate to a file."},
		  {"Name":"HashID","Description":"Hexadecimal representation of the FullName, AuditRank, IsActive, LastAccessTimeUtc, and LastWriteTimeUtc attributes."}
	]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TYPE',@level1name=N'DT_FileDetails'
GO
