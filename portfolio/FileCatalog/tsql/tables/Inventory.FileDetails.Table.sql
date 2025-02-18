CREATE TABLE Inventory.FileDetails(
	[_id] [int] IDENTITY(1,1) NOT NULL,
	[Ancestor1] [varchar](256) NULL,
	[AssignmentPriority] [char](1) NOT NULL,
	[AuditRank] [int] NOT NULL,
	[BaseName] [varchar](255) NULL,
	[CreationTimeUtc] [datetime2](0) NULL,
	[DirectoryName] [varchar](500) NULL,
	[Extension] [varchar](50) NULL,
	[FullName] [varchar](500) NOT NULL,
	[HashID] [varchar](64) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LastAccessTimeUtc] [datetime2](0) NULL,
	[LastWriteTimeUtc] [datetime2](0) NULL,
	[Length] [int] NOT NULL,
	[Owner] [varchar](60) NULL,
	[Parent] [varchar](128) NULL,
	[RowModifiedDateTime] [datetime2](0) NOT NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	[DataDisposition] [varchar](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DefFG],
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
) ON [DefFG]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [History].[FileDetails])
)
GO

ALTER TABLE [Inventory].[FileDetails] ADD  DEFAULT (sysutcdatetime()) FOR [RowModifiedDateTime]
GO
ALTER TABLE [Inventory].[FileDetails] ADD  CONSTRAINT [DF_FileDetails_SysStart]  DEFAULT (sysutcdatetime()) FOR [SysStartTime]
GO
ALTER TABLE [Inventory].[FileDetails] ADD  CONSTRAINT [DF_FileDetails_SysEnd]  DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) FOR [SysEndTime]
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
    "Creator": "Mark A. Dean",
    "DateIssued": "2024-09-11T16:07:10",
    "Description": "A temporal table that provides the current valid set of rows.",
    "Replaces": "Meta.FileDetails",
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
    "ResourceType": "TABLE",
    "Title": "MyDatabase.Inventory.FileDetails",
    "Version": "1.0.0",
    "Columns": [
        {
            "Name": "_id",
            "Description": "Row identity value."
        },
        {
            "Name": "Ancestor1",
            "Description": "The recognized first tier of the file directory system hierarchy. Might not be the highest directory in a path."
        },
        {
            "Name": "AssignmentPriority",
            "Description": "A simplified ranking determined by combinations of AuditRank ranges and the active status of a file."
        },
        {
            "Name": "AuditRank",
            "Description": "An integer value determined by the relationships of datetime elements, the active status, file extension type, and the detectable presence of a file owner."
        },
        {
            "Name": "BaseName",
            "Description": "The file name without the extension or URI elements."
        },
        {
            "Name": "CreationTimeUtc",
            "Description": "The date and time when the file was created."
        },
        {
            "Name": "DataDisposition",
            "Description": "The lifecycle action taken on content."
        },
        {
            "Name": "DirectoryName",
            "Description": "The full URI to the immediate directory of the file."
        },
        {
            "Name": "Extension",
            "Description": "The suffix that appears at the end of a file name to indicate the file type."
        },
        {
            "Name": "FullName",
            "Description": "The full URI of the file."
        },
        {
            "Name": "HashID",
            "Description": "Hexadecimal representation of the FullName, AuditRank, IsActive, LastAccessTimeUtc, and LastWriteTimeUtc attributes."
        },
        {
            "Name": "IsActive",
            "Description": "A Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date."
        },
        {
            "Name": "LastAccessTimeUtc",
            "Description": "The date and time in the UTC time zone when the current file was last accessed."
        },
        {
            "Name": "LastWriteTimeUtc",
            "Description": "The date and time in the UTC time zone when the current file was last written to."
        },
        {
            "Name": "Length",
            "Description": "The file size in kilobytes."
        },
        {
            "Name": "Owner",
            "Description": "The user who has full control over the file."
        },
        {
            "Name": "Parent",
            "Description": "The recognized tier of the file directory system hierarchy immediate to a file."
        },
        {
            "Name": "RowModifiedDateTime",
            "Description": "Date and time when the row was last modified."
        },
        {
            "Name": "SysEndTime",
            "Description": "The date and time until the row is no longer valid from a system point of view."
        },
        {
            "Name": "SysStartTime",
            "Description": "The date and time since the row has been valid from a system point of view."
        }
    ]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'FileDetails'
GO
