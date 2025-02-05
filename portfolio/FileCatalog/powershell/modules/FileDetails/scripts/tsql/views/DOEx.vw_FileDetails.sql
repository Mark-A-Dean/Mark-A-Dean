/*
  DOEx is a database schema that provides for explicit permissions on a database object.
  It is managed by Enterprise Database Administrators.
  It can be replaced with a more common database schema including __Inventory__.
*/
CREATE VIEW DOEx.vw_FileDetails
WITH SCHEMABINDING
AS
	SELECT x.BaseName,x.Ancestor1,x.Parent,x.Extension,x.IsActive,
	x.AssignmentPriority,x.AuditRank,x.DataDisposition,x.DirectoryName,x.Length,
	x.Owner,x.CreationTimeUtc,x.LastAccessTimeUtc,x.LastWriteTimeUtc,x.RowModifiedDateTime,x.FullName,x._id
	FROM Inventory.FileDetails As x
GO
CREATE UNIQUE CLUSTERED INDEX [idx_vw_FileDetails] ON [DOEx].[vw_FileDetails]
(
	[_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DefFG]
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
    "Creator": "Mark A. Dean",
    "DateIssued": "2024-11-26T14:21:14",
    "Description": "Returns a set of the current row versions from the Inventory.FileDetails table. Full text search is enabled on Ancestor1, Parent, and BaseName columns.",
    "Replaces": null,
    "Identifier": "MyDatabase.DOEx",
    "IsReplacedBy": null,
    "Status": "Stable",
    "State": "Approved",
    "ResourceType": "VIEW",
    "Title": "MyDatabase.DOEx.vw_FileDetails",
    "Version": "1.0.0",
    "Columns":[
        {"Name":"_id","Description":"Row identity value."},
		    {"Name":"BaseName","Description":"The file name without the extension or URI elements."},
        {"Name":"Ancestor1","Description":"The recognized first tier of the file directory system hierarchy. Might not be the highest directory in a path."},
		    {"Name":"Parent","Description":"The recognized tier of the file directory system hierarchy immediate to a file."},
        {"Name":"Extension","Description":"The suffix that appears at the end of a file name to indicate the file type."},
        {"Name":"IsActive","Description":"A Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date."},
        {"Name":"AssignmentPriority","Description":"A simplified ranking determined by combinations of AuditRank ranges and the active status of a file."},
		    {"Name":"AuditRank","Description":"An integer value determined by the relationships of datetime elements, the active status, file extension type, and the detectable presence of a file owner."},
		    {"Name":"DataDisposition","Description":"The lifecycle action taken on content."},
        {"Name":"DirectoryName","Description":"The full URI to the immediate directory of the file."},
		    {"Name":"Length","Description":"The file size in kilobytes."},
		    {"Name":"Owner","Description":"The user who has full control over the file."},
		    {"Name":"CreationTimeUtc","Description":"The date and time when the file was created."},
		    {"Name":"LastAccessTimeUtc","Description":"The date and time in the UTC time zone when the current file was last accessed."},
		    {"Name":"LastWriteTimeUtc","Description":"The date and time in the UTC time zone when the current file was last written to."},
		    {"Name":"RowModifiedDateTime","Description":"Date and time when the row was last modified."},
        {"Name":"FullName","Description":"The full URI of the file."},
        {"Name":"_id","Description":"Row identity value."}
	]
}' , @level0type=N'SCHEMA',@level0name=N'DOEx', @level1type=N'VIEW',@level1name=N'vw_FileDetails'
GO
