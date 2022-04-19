CREATE     FUNCTION Inventory.TopNDoexSubscriptions
(
	@nbr int = 5
)
RETURNS TABLE
AS RETURN
(
	SELECT NbrSubs As [Subscriptions],ServerName,ObjectSchema,ObjectName,DatabaseName,ObjectType
	FROM
	(
		SELECT ROW_NUMBER() OVER( Partition By i.ServerName Order By i.NbrSubs DESC) As RowNbr,i.* FROM
		(
			SELECT COUNT(ObjectName) As NbrSubs,ServerName,ObjectSchema,ObjectName,ObjectType,DatabaseName
			FROM Inventory.CDWDatabaseObjectPermission
			WHERE ObjectSchema = 'DOEX' AND PermissionType = 'Select'
			GROUP BY ServerName,ObjectSchema,ObjectName,ObjectType,DatabaseName
		) As i
	) As a
	WHERE a.RowNbr <= @nbr
)
GO
