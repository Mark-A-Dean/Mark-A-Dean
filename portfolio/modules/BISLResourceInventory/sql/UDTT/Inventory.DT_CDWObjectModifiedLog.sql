CREATE TYPE [Inventory].[DT_CDWObjectModifiedLog] AS TABLE(
	[ObjectName] [varchar](60) NULL,
	[Value] [datetime2](0) NULL
)
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TYPE',@level1name=N'DT_CDWObjectModifiedLog'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Serves as the Table Value Parameter for the Inventory.ManageCDWObjectModifiedLog procedure.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TYPE',@level1name=N'DT_CDWObjectModifiedLog'
GO