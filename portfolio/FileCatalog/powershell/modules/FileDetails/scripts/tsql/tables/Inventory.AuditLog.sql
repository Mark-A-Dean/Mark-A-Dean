CREATE TABLE Inventory.AuditLog(
	[_id] [int] IDENTITY(1,1) NOT NULL,
	[Auditor] [varchar](60) NULL,
	[CreationTimeUtc] [datetime2](0) NULL,
	[Description] [varchar](500) NULL,
	[DirectoryName] [varchar](256) NULL,
	[EventDate] [varchar](10) NULL,
	[EventName] [varchar](60) NULL,
	[EventState] [varchar](12) NULL,
	[FullName] [varchar](500) NULL,
	[HashID] [varchar](64) NULL,
	[LastAccessTimeUtc] [datetime2](0) NULL,
	[LastWriteTimeUtc] [datetime2](0) NULL,
	[Manifest] [nvarchar](4000) NULL,
	[Parent] [varchar](256) NULL,
	[RowModifiedDateTime] [datetime2](0) NULL,
PRIMARY KEY CLUSTERED 
(
	[_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DefFG]
) ON [DefFG]
GO

ALTER TABLE [Inventory].[AuditLog] ADD  DEFAULT (sysutcdatetime()) FOR [RowModifiedDateTime]
GO
ALTER TABLE [Inventory].[AuditLog]  WITH CHECK ADD  CONSTRAINT [CK_mainfest] CHECK  ((isjson([Manifest])=(1)))
GO
ALTER TABLE [Inventory].[AuditLog] CHECK CONSTRAINT [CK_mainfest]
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-01-07T20:39:25",
    "Description": "Stores audit log files data involved with the File Catalog project.",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "TABLE",
    "Title": "MyDatabase.Inventory.AuditLog",
    "Version": "2.0.0",
    "Columns":[
        {"Name":"_id","Description":"Primary key. Identity value on the table row."},
        {"Name":"Auditor","Description":"The Active Directory account of the person who reviewed the files in the current directory."},
		    {"Name":"CreationTimeUtc","Description":"The date and time when the file was created."},
		    {"Name":"Description","Description":"An account of the event."},
		    {"Name":"DirectoryName","Description":"The full URI to the immediate directory of the file."},
		    {"Name":"EventDate","Description":"The date when the event occurred in `yyyy-mm-dd` format."},
		    {"Name":"EventName","Description":"The name of the action taken: i.e., Audit."},
		    {"Name":"EventState","Description":"The state of the audit; pre-approval,approved,hold,rejected."},
		    {"Name":"FullName","Description":"The full URI of the file."},
		    {"Name":"HashID","Description":"Hexadecimal representation of the FullName, CreationTimeUtc, LastAccessTimeUtc, and LastWriteTimeUtc attributes."},
		    {"Name":"LastAccessTimeUtc","Description":"The date and time in the UTC time zone when the current file was last accessed."},
		    {"Name":"LastWriteTimeUtc","Description":"The date and time in the UTC time zone when the current file was last written to."},
		    {"Name":"Manifest","Description":"The audit file contents stored in a compressed JSON format."},
		    {"Name":"Parent","Description":"The file directory to the path of BIO team file share. Provides identifying redundancy."},
		    {"Name":"RowModifiedDateTime","Description":"Date and time when the row was last modified."}
	]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'AuditLog'
GO
