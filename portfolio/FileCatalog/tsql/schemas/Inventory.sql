CREATE SCHEMA Inventory
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
        "Creator": "Mark A. Dean",
        "DateIssued": "2024-09-11T14:38:53",
        "Description": "Owns data objects intended for an inventory purpose.",
        "Replaces": null,
        "Identifier": "MyDatabase.Inventory",
        "IsReplacedBy": null,
        "Status": "Steady",
        "State": "Approved",
        "ResourceType": "Schema",
        "Title": "MyDatabase.Inventory.Inventory",
        "Version": "1.0.0"
}' , @level0type=N'SCHEMA',@level0name=N'Inventory'
GO
