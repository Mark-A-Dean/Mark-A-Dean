CREATE PROCEDURE Inventory.ManageFileDetailsRoot
    @dt Inventory.DT_FileDetailsRoot READONLY
AS
OnInsert:
	INSERT INTO Inventory.FileDetailsRoot(RootPath,RootDirectoryName,SubdirectoryQuery)
	SELECT st.RootPath,st.RootDirectoryName,st.SubdirectoryQuery
    FROM @dt As st

	EXECUTE Dflt.SetExtendedProperties_L1 'Inventory','FileDetailsRoot','U';
RETURN 0
GO

DECLARE @dateIssued varchar(20) = (SELECT FORMAT(SYSUTCDATETIME(),'yyyy-MM-ddTHH:mm:ss'));
DECLARE @jDesc varchar(4000) = N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "'+@dateIssued+'",
    "Description": "Manages data in the Type 2 SCD Inventory.ManageFileDetailsRoot base table.",
    "Replaces": null,
    "Identifier": "MyDatabase.Inventory",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "PROCEDURE",
    "Title": "MyDatabase.Inventory.ManageFileDetailsRoot",
    "Version": "1.0.0",
    "Parameters":[
        {"Name":"@dt","Description":"READONLY table-valued parameter of the Inventory.DT_FileDetailsRoot type."}
	]
}'
EXEC sys.sp_addextendedproperty	@name=N'Header', 
	@value=@jDesc,
	@level0type=N'SCHEMA', 
	@level0name=N'Inventory', 
	@level1type=N'PROCEDURE', 
	@level1name=N'ManageFileDetailsRoot'
GO
