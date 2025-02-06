CREATE SCHEMA History
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
        "Creator": "Mark A. Dean",
        "DateIssued": "2024-09-11T14:40:05",
        "Description": "Owns data objects designated for system versioning.",
        "Replaces": null,
        "Identifier": "MyDatabase.History",
        "IsReplacedBy": null,
        "Status": "Steady",
        "State": "Approved",
        "ResourceType": "Schema",
        "Title": "MyDatabase.History.History",
        "Version": "1.0.0"
}' , @level0type=N'SCHEMA',@level0name=N'History'
GO
