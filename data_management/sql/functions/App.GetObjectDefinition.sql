CREATE FUNCTION [App].[GetObjectDefinition](@object_nm varchar(128)=NULL)
RETURNS @reportTable TABLE
(
	object_name	sql_variant
	,exists_on varchar(128)
	,major_id int
	,class tinyint
	,class_desc nvarchar(60)
	,minor_id int
	,property sql_variant
	,description sql_variant
	,type_desc nvarchar(60)
)
AS
BEGIN
	DECLARE @schema_nm varchar(50)
	DECLARE @wrk_nm varchar(128)
	DECLARE @object_id int
	
	IF ( SELECT CHARINDEX('.',@object_nm) ) > 1 
	BEGIN
	    SET @schema_nm = SUBSTRING(@object_nm,1,CHARINDEX('.',@object_nm)-1)
	    SET @wrk_nm = REPLACE(@object_nm,@schema_nm+'.','')
	    SET @object_id = (
	    	SELECT o.object_id FROM sys.objects As o
	    	INNER JOIN sys.schemas As s
	    	ON s.schema_id = o.schema_id
	    	WHERE o.name = @wrk_nm AND s.name = @schema_nm
	    	UNION
	    	SELECT tt.user_type_id
	    	FROM sys.table_types As tt
	    	INNER JOIN sys.schemas As s
	    	ON s.schema_id = tt.schema_id
	    	WHERE tt.name = @wrk_nm AND s.name = @schema_nm
	    )
	END
	ELSE
	BEGIN
	    	SET @object_id = (
			SELECT i.object_id
	    	FROM sys.Indexes As i
	    	WHERE i.name = @object_nm
	    )
	END
	IF @object_nm IS NOT NULL
	BEGIN
		INSERT INTO @reportTable
		SELECT TOP 100 PERCENT 'object_name' = CASE
			WHEN class = 1 AND minor_id > 0 THEN c.name
			WHEN class = 1 AND minor_id = 0 THEN @object_nm
			WHEN class = 2 AND minor_id > 0 THEN p.name
			WHEN class = 3 THEN (SELECT DISTINCT s.name FROM sys.schemas As s WHERE s.schema_id=ext.major_id)
			WHEN class = 6 THEN (SELECT t.name FROM sys.types As t WHERE t.user_type_id = ext.major_id)
			WHEN class = 7 THEN idx.name
			WHEN class = 8 THEN (
		        SELECT c.name
				FROM sys.columns As c
				INNER JOIN [sys].[table_types] As tt
				ON c.object_id = tt.type_table_object_id
				WHERE tt.user_type_id = ext.major_id AND c.column_id = ext.minor_id )
			WHEN class = 10 THEN (SELECT x.name FROM sys.xml_schema_collections AS x WHERE x.xml_collection_id = ext.major_id)
			END
		,exists_on = CASE
			WHEN class = 0 then 'Database'
			WHEN class IN (1,2,7) THEN OBJECT_NAME(major_id)
			WHEN class IN(6, 8) THEN (SELECT t.name FROM sys.types As t WHERE t.user_type_id = ext.major_id)
			WHEN class = 3 THEN DB_Name()
			END
		,ext.major_id
		,ext.class
		,class_desc
		,ext.minor_id
		,ext.name AS [property]
		,ext.value AS [description]
		,ext.class_desc
		FROM sys.extended_properties AS ext
		LEFT OUTER JOIN sys.objects As o
		ON o.object_id = ext.major_id
		LEFT OUTER JOIN sys.columns AS c
		ON c.object_id = ext.major_id AND c.column_id = ext.minor_id
		LEFT OUTER JOIN sys.parameters AS p
		ON p.object_id = ext.major_id AND p.parameter_id = ext.minor_id
		LEFT OUTER JOIN sys.indexes As idx
		ON idx.object_id = ext.major_id AND idx.index_id=ext.minor_id
		WHERE ext.major_id = @object_id
	RETURN
	END
	
	IF @object_nm IS NULL
	BEGIN
	INSERT INTO @reportTable
	SELECT TOP 100 PERCENT 'object_name' = CASE
		WHEN class = 1 AND minor_id > 0 THEN c.name
		WHEN class = 1 AND minor_id = 0 THEN OBJECT_NAME(major_id)
		WHEN class = 2 AND minor_id > 0 THEN p.name
		WHEN class = 3 THEN (SELECT DISTINCT s.name FROM sys.schemas As s WHERE s.schema_id=ext.major_id)
		WHEN class = 6 THEN (SELECT t.name FROM sys.types As t WHERE t.user_type_id = ext.major_id)
		WHEN class = 7 THEN idx.name
		WHEN class = 8 THEN (
	        SELECT c.name
			FROM sys.columns As c
			INNER JOIN [sys].[table_types] As tt
			ON c.object_id = tt.type_table_object_id
			WHERE tt.user_type_id = ext.major_id AND c.column_id = ext.minor_id)
		END
	,exists_on = CASE
		WHEN class = 0 then 'Database'
		WHEN class IN (1,2,7) THEN OBJECT_NAME(major_id)
		WHEN class = 3 THEN DB_Name()
		WHEN class IN(6, 8) THEN (SELECT t.name FROM sys.types As t WHERE t.user_type_id = ext.major_id)
		END
	,ext.major_id
	,ext.class
	,ext.class_desc
	,ext.minor_id
	,ext.name AS [property]
	,ext.value AS [description]
	,type_desc = CASE
		WHEN class = 7 THEN idx.type_desc
		WHEN class = 3 THEN 'SCHEMA'
		WHEN class IN(6,8) THEN ext.class_desc
		ELSE o.type_desc
		END
	FROM sys.extended_properties AS ext
	LEFT OUTER JOIN sys.objects As o
	ON o.object_id = ext.major_id
	LEFT OUTER JOIN sys.columns AS c
	ON c.object_id = ext.major_id AND c.column_id = ext.minor_id
	LEFT OUTER JOIN sys.parameters AS p
	ON p.object_id = ext.major_id AND p.parameter_id = ext.minor_id
	LEFT OUTER JOIN sys.indexes As idx
	ON idx.object_id = ext.major_id AND idx.index_id=ext.minor_id
	END
	
	RETURN
END

GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Fully declared name of the object. Ex. dbo.SomeTable' , @level0type=N'SCHEMA',@level0name=N'App', @level1type=N'FUNCTION',@level1name=N'GetObjectDefinition', @level2type=N'PARAMETER',@level2name=N'@object_nm'
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'App', @level1type=N'FUNCTION',@level1name=N'GetObjectDefinition'
GO

EXEC sys.sp_addextendedproperty @name=N'Data Sources', @value=N'sys.extended_properties, sys.objects, sys.columns, sys.parameters' , @level0type=N'SCHEMA',@level0name=N'App', @level1type=N'FUNCTION',@level1name=N'GetObjectDefinition'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Returns the extended properties for a specified database object (i.e. table, view, procedure, or function).' , @level0type=N'SCHEMA',@level0name=N'App', @level1type=N'FUNCTION',@level1name=N'GetObjectDefinition'
GO

EXEC sys.sp_addextendedproperty @name=N'How To Use', @value=N'SELECT * FROM Dflt.GetObjectDefinition( [schema_name.object_name])' , @level0type=N'SCHEMA',@level0name=N'App', @level1type=N'FUNCTION',@level1name=N'GetObjectDefinition'
GO

EXEC sys.sp_addextendedproperty @name=N'Returned Columns', @value=N'object_name: The name of the object to which the extended property belongs. 
	,exists_on: Identifies the itemon which the property is exists. 
	,class: Identifies the class of item on which the property exists.
	,class_desc: Description of the class on which the extended property exists. 
	,minor_id: Secondary ID of the item on which the extended property exists, interpreted according to its class. For most items this is 0; otherwise, the ID is as follows: If class = 1, minor_id is the column_id if column, else 0 if object. If class = 2, minor_id is the parameter_id. If class 7 = minor_id is the index_id. 
	,property: Property name, unique with class, major_id, and minor_id. 
	,description: Value of the extended property. 
	,type_desc: Description of the object type.
' , @level0type=N'SCHEMA',@level0name=N'App', @level1type=N'FUNCTION',@level1name=N'GetObjectDefinition'
GO
