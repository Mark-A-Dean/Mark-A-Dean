CREATE TABLE [Inventory].[CDWObjectModifiedLog](
	[_id] [int] IDENTITY(1,1) NOT NULL,
	[ObjectName] [varchar](60) NOT NULL,
	[Value] [datetime2](0) NOT NULL,
	[RowModifiedDateTime] [datetime2](0) NULL,
 CONSTRAINT [PK__CDWObjec__5B8F1485EE979D32] PRIMARY KEY CLUSTERED 
(
	[_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DefFG]
) ON [DefFG]
GO

ALTER TABLE [Inventory].[CDWObjectModifiedLog] ADD  CONSTRAINT [DF__ObjectMod__RowMo__336AA144]  DEFAULT (sysutcdatetime()) FOR [RowModifiedDateTime]
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Primary key. Identity value for the table row.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'CDWObjectModifiedLog', @level2type=N'COLUMN',@level2name=N'_id'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'The name of the database object.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'CDWObjectModifiedLog', @level2type=N'COLUMN',@level2name=N'ObjectName'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Value of the extended property.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'CDWObjectModifiedLog', @level2type=N'COLUMN',@level2name=N'Value'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Date and time when the row was last modified. The date and time is returned as UTC time (Coordinated Universal Time)' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'CDWObjectModifiedLog', @level2type=N'COLUMN',@level2name=N'RowModifiedDateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'CDWObjectModifiedLog'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Stores the name of the Inventory Object and the timestamp of when the object was last modified by the BISL Resource Inventory workflow.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'CDWObjectModifiedLog'
GO