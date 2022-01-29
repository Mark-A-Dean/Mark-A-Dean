CREATE OR ALTER   PROCEDURE [Inventory].[ManageCDWObjectModifiedLog]
    @dt Inventory.DT_CDWObjectModifiedLog READONLY
AS
    INSERT INTO Inventory.CDWObjectModifiedLog(ObjectName,[Value])
	SELECT a.ObjectName,a.Value FROM @dt As a
RETURN 0 
GO

IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Creator' , N'SCHEMA',N'Inventory', N'PROCEDURE',N'ManageCDWObjectModifiedLog', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageCDWObjectModifiedLog'
ELSE
BEGIN
	EXEC sys.sp_updateextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageCDWObjectModifiedLog'
END
GO

IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Description' , N'SCHEMA',N'Inventory', N'PROCEDURE',N'ManageCDWObjectModifiedLog', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Executes An Insert statement on the Inventory.CDWObjectModifiedLog table.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageCDWObjectModifiedLog'
ELSE
BEGIN
	EXEC sys.sp_updateextendedproperty @name=N'Description', @value=N'Executes An Insert statement on the Inventory.CDWObjectModifiedLog table.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageCDWObjectModifiedLog'
END
GO
