CREATE SCHEMA [Report]
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
        "Creator": "Mark A. Dean",
        "DateIssued": "2024-09-11T14:40:05",
        "Description": "Owns data objects designated for reporting.",
        "Replaces": null,
        "Identifier": "MyDatabase.Report",
        "IsReplacedBy": null,
        "Status": "Steady",
        "State": "Approved",
        "ResourceType": "Schema",
        "Title": "MyDatabase.Report.Report",
        "Version": "1.0.0"
}' , @level0type=N'SCHEMA',@level0name=N'Report'
GO
