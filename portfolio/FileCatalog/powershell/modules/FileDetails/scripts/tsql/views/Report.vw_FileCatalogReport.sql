CREATE VIEW Report.vw_FileCatalogReport
As
SELECT a1.* FROM(
	SELECT
	SUM(CASE WHEN a.Extension='.csv' THEN 1 ELSE 0 END) As 'NbrCSV',
	SUM(CASE WHEN a.Extension='.doc' OR a.Extension='.docx' THEN 1 ELSE 0 END) As 'NbrDocx',
	SUM(CASE WHEN a.Extension='.msg' THEN 1 ELSE 0 END) As 'NbrMsg',
	SUM(CASE WHEN a.Extension='.sql' THEN 1 ELSE 0 END) As 'NbrSql',
	SUM(CASE WHEN a.Extension='.xls' OR a.Extension='.xlsx' THEN 1 ELSE 0 END) As 'NbrXlsx',
	SUM(CASE WHEN a.Extension NOT IN ('.csv','.doc','.docx','.msg','sql','.xls','.xlsx') THEN 1 ELSE 0 END) As 'NbrOther',
	COUNT(*) As 'NbrFilesInventoried',
	COUNT(DISTINCT a.DirectoryName) As 'NbrDirectoriesInventoried',
	CONVERT(decimal(10,2),SUM(a.Length)/1048576) As 'SizeGBInventoried'
	FROM Inventory.FileDetails As a
) As a
CROSS APPLY(
	VALUES
	(1,'NbrCSV',CONVERT(varchar(10),a.NbrCSV)),
	(2,'NbrDocx',CONVERT(varchar(10),a.NbrDocx)),
	(3,'NbrMsg',CONVERT(varchar(10),a.NbrMsg)),
	(4,'NbrSql',CONVERT(varchar(10),a.NbrSql)),
	(5,'NbrXlsx',CONVERT(varchar(10),a.NbrXlsx)),
	(6,'NbrOther',CONVERT(varchar(10),a.NbrOther)),
	(7,'NbrFilesInventoried',CONVERT(varchar(10),a.NbrFilesInventoried)),
	(8,'NbrDirectoriesInventoried',CONVERT(varchar(10),a.NbrDirectoriesInventoried)),
	(9,'SizeGBInventoried',CONVERT(varchar(10),a.SizeGBInventoried)),
	(10,'InventoryCycleDate',FORMAT(Inventory.GetCycleDate('Inventory.FileDetails'),
		'yyyy-MM-dd',
		'en-US'
		)
	)
) As a1(ordinal,name,value)
GO

EXEC sys.sp_addextendedproperty @name=N'Header', @value=N'{
	"Creator": "Mark A. Dean",
    "DateIssued": "2025-01-30T16:23:04",
    "Description": "Returns a pivoted set of Name/Value pairs from the Report.vw_FileCatalogReport table in Power BI.",
    "Replaces": "1.5.0",
    "Identifier": "MyDatabase.Report",
    "IsReplacedBy": null,
    "Status": "Steady",
    "State": "Approved",
	"ResourceType": "VIEW",
    "Title": "MyDatabase.Report.vw_FileCatalogReport",
    "Version": "2.0.0",
    "Columns": [
		{
            "Name": "ordinal",
            "Description": "Relating to the position of an instance within a series."
        },
        {
            "Name": "name",
            "Description": "A derived column that contains a labeling that identifies a value in the Value column."
        },
        {
            "Name": "value",
            "Description": "The value for each base table column identified by the view-derived Name column."
        }
    ]
}' , @level0type=N'SCHEMA',@level0name=N'Report', @level1type=N'VIEW',@level1name=N'vw_FileCatalogReport'
GO
