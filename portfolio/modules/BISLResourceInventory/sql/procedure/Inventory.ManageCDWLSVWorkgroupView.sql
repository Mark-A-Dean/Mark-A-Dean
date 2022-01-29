CREATE PROCEDURE Inventory.ManageCDWLSVWorkgroupView
    @dt Inventory.DT_CDWLSVWorkgroupView READONLY
AS
	UPDATE tt
	SET tt.CreateDate = st.CreateDate
	,tt.CriticalColumnCount = st.CriticalColumnCount
	,tt.CriticalColumns = st.CriticalColumns
	,tt.DateLastModified = st.DateLastModified
	,tt.HasAfterTrigger = st.HasAfterTrigger
	,tt.HasDataSetFilter = st.HasDataSetFilter
	,tt.HasDeleteTrigger = st.HasDeleteTrigger
	,tt.HasExtendedProperties = st.HasExtendedProperties
	,tt.HasFullTextIndex = st.HasFullTextIndex
	,tt.HasIndex = st.HasIndex
	,tt.HasInsertTrigger = st.HasInsertTrigger
	,tt.HasInsteadOfTrigger = st.HasInsteadOfTrigger
	,tt.HasPAIDBool = st.HasPAIDBool
	,tt.HasPHIPIIBool = st.HasPHIPIIBool
	,tt.HasSDataExpression = st.HasSDataExpression
	,tt.HasUpdateTrigger = st.HasUpdateTrigger
	,tt.ID = st.ID
	,tt.IsDeveloperSecured = st.IsDeveloperSecured
	,tt.IsEncrypted = st.IsEncrypted
	,tt.IsIndexable = st.IsIndexable
	,tt.IsSchemaBound = st.IsSchemaBound
	,tt.Name = st.Name
	,tt.NbrColumns = st.NbrColumns
	,tt.Owner = st.Owner
	,tt.ParentGuid = st.ParentGuid
	,tt.ParentName = st.ParentName
	,tt.ReturnsViewMetadata = st.ReturnsViewMetadata
	,tt.SchemaName = st.SchemaName
	,tt.ServerName = st.ServerName
	,tt.State = st.State
	,tt.TextMode = st.TextMode
	,tt.Urn = st.Urn
	,tt.HashID = st.HashID
	FROM Inventory.CDWLSVWorkgroupView As tt
	INNER JOIN @dt As st
	ON st.Urn = tt.Urn AND (st.HashID != tt.HashID OR tt.HashID IS NULL)

	INSERT INTO Inventory.CDWLSVWorkgroupView(CreateDate, CriticalColumnCount, CriticalColumns, DateLastModified, HasAfterTrigger, HasDataSetFilter, HasDeleteTrigger, HasExtendedProperties, HasFullTextIndex, HasIndex, HasInsertTrigger, HasInsteadOfTrigger, HasPAIDBool, HasPHIPIIBool, HasSDataExpression, HasUpdateTrigger, ID, IsDeveloperSecured, IsEncrypted, IsIndexable, IsSchemaBound, Name, NbrColumns, Owner, ParentGuid, ParentName, ReturnsViewMetadata, SchemaName, ServerName, State, TextMode, Urn, HashID)
        SELECT st.CreateDate,st.CriticalColumnCount,st.CriticalColumns,st.DateLastModified,st.HasAfterTrigger,st.HasDataSetFilter,st.HasDeleteTrigger,st.HasExtendedProperties,st.HasFullTextIndex,st.HasIndex,st.HasInsertTrigger,st.HasInsteadOfTrigger,st.HasPAIDBool, st.HasPHIPIIBool,st.HasSDataExpression,st.HasUpdateTrigger,st.ID,st.IsDeveloperSecured,st.IsEncrypted,st.IsIndexable, st.IsSchemaBound,st.Name,st.NbrColumns,st.Owner,st.ParentGuid,st.ParentName,st.ReturnsViewMetadata,st.SchemaName, st.ServerName,st.State,st.TextMode,st.Urn,st.HashID
        FROM @dt As st
        LEFT OUTER JOIN Inventory.CDWLSVWorkgroupView As tt
        ON tt.Urn = st.Urn
        WHERE tt.Urn IS NULL;

	DELETE tt
		FROM Inventory.CDWLSVWorkgroupView As tt
		LEFT OUTER JOIN @dt As st
		ON st.Urn = tt.Urn
		WHERE st.Urn IS NULL;

	RETURN 0
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageCDWLSVWorkgroupView'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Executes Update, Insert, and Delete statements on the Inventory.CDWLSVWorkgroupView table.' , @level0type=N'SCHEMA',@level0name=N'Inventory', @level1type=N'PROCEDURE',@level1name=N'ManageCDWLSVWorkgroupView'
GO