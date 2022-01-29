CREATE TABLE [Inventory].[CDWLSVWorkgroupView]
(
	[_id] [int] IDENTITY(1,1) NOT NULL,
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
	[HashID] [varchar](64) NOT NULL,
	[RowModifiedDateTime] [datetime2](0) NULL,
PRIMARY KEY CLUSTERED 
(
	[_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DefFG]
) ON [DefFG]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IDX_CDWLSVWorkgroupView_Urn]    Script Date: 1/12/2022 11:02:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_CDWLSVWorkgroupView_Urn] ON [Inventory].[CDWLSVWorkgroupView]
(
	[Urn] ASC
)
INCLUDE([ServerName],[ParentName],[SchemaName],[Name],[CriticalColumnCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DefFG]
GO

ALTER TABLE [Inventory].[CDWLSVWorkgroupView] ADD  DEFAULT (sysutcdatetime()) FOR [RowModifiedDateTime]
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Unique index that constrains the Urn system identifier.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'TABLE',@level1name=N'CDWLSVWorkgroupView', @level2type=N'INDEX',@level2name=N'IDX_CDWLSVWorkgroupView_Urn'
GO


