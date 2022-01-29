CREATE TYPE Inventory.DT_CDWLSVWorkgroupView AS TABLE
(
	[CreateDate] [datetime2](0) NULL,
	[CriticalColumnCount] [int] NULL,
	[CriticalColumns] [varchar](4000) NULL,
	[DateLastModified] [datetime2](0) NULL,
	[HasAfterTrigger] [bit] NOT NULL,
	[HasDataSetFilter] [bit] NOT NULL,
	[HasDeleteTrigger] [bit] NOT NULL,
	[HasExtendedProperties] [bit] NOT NULL,
	[HasFullTextIndex] [bit] NOT NULL,
	[HasIndex] [bit] NOT NULL,
	[HasInsertTrigger] [bit] NOT NULL,
	[HasInsteadOfTrigger] [bit] NOT NULL,
	[HasPAIDBool] [bit] NOT NULL,
	[HasPHIPIIBool] [bit] NOT NULL,
	[HasSDataExpression] [bit] NOT NULL,
	[HasUpdateTrigger] [bit] NOT NULL,
	[ID] [int] NULL,
	[IsDeveloperSecured] [bit] NOT NULL,
	[IsEncrypted] [bit] NOT NULL,
	[IsIndexable] [bit] NOT NULL,
	[IsSchemaBound] [bit] NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[NbrColumns] [int] NULL,
	[Owner] [varchar](128) NULL,
	[ParentGuid] [uniqueidentifier] NULL,
	[ParentName] [varchar](128) NOT NULL,
	[ReturnsViewMetadata] [bit] NOT NULL,
	[SchemaName] [varchar](128) NULL,
	[ServerName] [varchar](128) NULL,
	[State] [varchar](23) NULL,
	[TextMode] [bit] NOT NULL,
	[Urn] [varchar](577) NOT NULL,
	[HashID] [varchar](64) NOT NULL
)
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TYPE',@level1name=N'DT_CDWLSVWorkgroupView'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Serves as the Table Value Parameter for the Inventory.ManageCDWLSVWorkgroupView procedure.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TYPE',@level1name=N'DT_CDWLSVWorkgroupView'
GO


