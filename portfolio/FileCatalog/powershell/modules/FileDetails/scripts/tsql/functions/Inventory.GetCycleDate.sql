CREATE FUNCTION Inventory.GetCycleDate
(
    @object_name varchar(128)
)
RETURNS datetime2(0)
AS
BEGIN
	DECLARE @result datetime2(0);
    SELECT @result=CONVERT(datetime2(0),a.value)
    FROM sys.extended_properties As a
    WHERE a.name='Modified' AND a.major_id=OBJECT_ID(@object_name);
	RETURN @result;
END
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-01-28T22:14:13",
    "Description": "Returns the extended property datetime value for the last modification of the database object.",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "FUNCTION",
    "Title": "MyDatabase.Inventory.GetCycleDate",
    "Version": "1.0.0",
    "Parameters":[
        {"Name":"@object_name","Description":"The schema and name of the database object that has been modified."}
    ]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'FUNCTION',@level1name=N'GetCycleDate'
GO
