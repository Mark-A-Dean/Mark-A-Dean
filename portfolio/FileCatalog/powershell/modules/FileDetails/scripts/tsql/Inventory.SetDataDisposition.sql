CREATE FUNCTION Inventory.SetDataDisposition(
	@assignmentPriorityGroup varchar(140)
)
RETURNS varchar(20)
AS
BEGIN
	DECLARE @result varchar(20);
	WITH CTE_GET As(
		SELECT DISTINCT [TheValue] = [value]
		FROM string_split(@assignmentPriorityGroup,CHAR(32))
	)
	SELECT @result=CASE
		WHEN EXISTS(
			SELECT TOP 1 1 FROM CTE_GET WHERE TheValue IN('A','B','C')) THEN 'keep'
		WHEN EXISTS(
			SELECT TOP 1 1 FROM CTE_GET WHERE TheValue = 'D') THEN 'archive'
		WHEN EXISTS(
			SELECT TOP 1 1 FROM CTE_GET WHERE TheValue IN('E','F')) THEN 'purge'
		ELSE 'i'
		END;
	RETURN @result;
END
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2024-10-03T15:26:06",
    "Description": "Sets the data disposition for the Parent (immediate directory) based on the file directory''s greatest file assignment priority (A > F).",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "FUNCTION",
    "Title": "MyDatabase.Inventory.SetDataDisposition",
    "Version": "1.0.0",
    "Parameters":[
        {"Name":"@assignmentPriorityGroup","Description":"A space-delimited list element containing all the file assignment priorities for a given Parent."}
    ]
}' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'FUNCTION',@level1name=N'SetDataDisposition'
GO
