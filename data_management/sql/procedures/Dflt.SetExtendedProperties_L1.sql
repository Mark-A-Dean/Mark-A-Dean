CREATE   PROCEDURE [Dflt].[SetExtendedProperties_L1]
    @SchemaName varchar(60)
    ,@ObjectName varchar(60)
    ,@ObjectTypeAbrv varchar(2) NULL
AS
IF( @ObjectTypeAbrv IN ('AF','D','F','LF','P','SQ','R','SO','SN','U','TT','T','V','XS',NULL) )
	BEGIN
	DECLARE @ObjectType varchar(60) = (SELECT CASE
		WHEN @ObjectTypeAbrv = 'AF' THEN 'AGGREGATE'
		WHEN @ObjectTypeAbrv = 'D' THEN 'DEFAULT'
		WHEN @ObjectTypeAbrv = 'F'	THEN 'FUNCTION'
		WHEN @ObjectTypeAbrv = 'LF'	THEN 'LOGICAL FILE NAME'
		WHEN @ObjectTypeAbrv = 'P'	THEN 'PROCEDURE'
		WHEN @ObjectTypeAbrv = 'SQ'	THEN 'QUEUE'
		WHEN @ObjectTypeAbrv = 'R'	THEN 'RULE'
		WHEN @ObjectTypeAbrv = 'SO'	THEN 'SEQUENCE'
		WHEN @ObjectTypeAbrv = 'SN'	THEN 'SYNONYM'
		WHEN @ObjectTypeAbrv = 'U'	THEN 'TABLE'
		WHEN @ObjectTypeAbrv = 'TT'	THEN 'TABLE_TYPE'
		WHEN @ObjectTypeAbrv = 'T'	THEN 'TYPE'
		WHEN @ObjectTypeAbrv = 'V'	THEN 'VIEW'
		WHEN @ObjectTypeAbrv = 'XS'	THEN 'XML SCHEMA COLLECTION'
		WHEN @ObjectTypeAbrv IS NULL THEN NULL
		END)
	END
	ELSE
		BEGIN
		PRINT 'ObjectTypeAbrv must be one of the following: AF, D, F, LF, P, SQ, R, SO, SN, U, TT, T, V, XS, or NULL'
		RETURN
	END

BEGIN TRY
	DECLARE @modified datetime = (SELECT SYSUTCDATETIME());
	DECLARE @modifiedBy varchar(60) = (SELECT SUSER_NAME());
	DECLARE @objectString varchar(120) = @SchemaName+'.'+@ObjectName;

	IF NOT EXISTS (SELECT NULL FROM SYS.EXTENDED_PROPERTIES WHERE [major_id] = OBJECT_ID(''+@objectString+'') AND [name] = N'Modified' AND [minor_id] = 0)
	BEGIN
	EXEC sys.sp_addextendedproperty @name=N'Modified',@value= @modified,@level0type=N'SCHEMA',@level0name=@SchemaName,@level1type=@ObjectType,@level1name=@ObjectName
	END
	ELSE EXEC sys.sp_updateextendedproperty @name=N'Modified',@value= @modified,@level0type=N'SCHEMA',@level0name=@SchemaName,@level1type=@ObjectType,@level1name=@ObjectName

	IF NOT EXISTS (SELECT NULL FROM SYS.EXTENDED_PROPERTIES WHERE [major_id] = OBJECT_ID(@objectString) AND [name] = N'ModifiedBy' AND [minor_id] = 0)
	BEGIN
	EXEC sys.sp_addextendedproperty @name=N'ModifiedBy',@value=@modifiedBy,@level0type=N'SCHEMA',@level0name=@SchemaName,@level1type=@ObjectType,@level1name=@ObjectName
	END
	ELSE EXEC sys.sp_updateextendedproperty @name=N'ModifiedBy',@value=@modifiedBy,@level0type=N'SCHEMA',@level0name=@SchemaName,@level1type=@ObjectType,@level1name=@ObjectName;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
RETURN 0;
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Dflt', @level1type=N'PROCEDURE',@level1name=N'SetExtendedProperties_L1'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Sets Level 1 extended properties on a database object.' , @level0type=N'SCHEMA',@level0name=N'Dflt', @level1type=N'PROCEDURE',@level1name=N'SetExtendedProperties_L1'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the database schema for the database object.' , @level0type=N'SCHEMA',@level0name=N'Dflt', @level1type=N'PROCEDURE',@level1name=N'SetExtendedProperties_L1', @level2type=N'PARAMETER',@level2name=N'@SchemaName'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the database object.' , @level0type=N'SCHEMA',@level0name=N'Dflt', @level1type=N'PROCEDURE',@level1name=N'SetExtendedProperties_L1', @level2type=N'PARAMETER',@level2name=N'@ObjectName'
GO
