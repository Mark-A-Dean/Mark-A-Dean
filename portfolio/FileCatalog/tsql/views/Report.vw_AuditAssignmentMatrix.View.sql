/*
  ## Experimental
  This is a relatively new file and it lacks the extended properties.
  The view shreds the JSON data loaded in the base table. Care should be taken as 
  the base table is designed to hold only one row currently.
  
  The __Report__ database schema is likewise missing descriptive metadata.
*/
CREATE VIEW Report.vw_AuditAssignmentMatrix As
SELECT b.IsActive,b.Description As State_Description,b.IsDefault,
c.Level,c.Letter,c.Description As Priority_Description,
d.AuditRank,d.Interpretation,d.Comment,d.HasOwner
FROM Inventory.AuditAssignmentMatrix As a
CROSS APPLY OPENJSON(a.matrix,'$.States') As a1
CROSS APPLY OPENJSON(a1.value)
WITH(
	IsActive bit '$.is_active',
	Description varchar(258) '$.description',
	IsDefault bit '$.is_default',
	AssignmentPriorities nvarchar(max) '$.assignment_priorities' AS JSON
) As b
CROSS APPLY OPENJSON(b.AssignmentPriorities)
WITH(
	[Level] varchar(6) '$.level',
	Letter char(1) '$.letter',
	Description varchar(258) '$.description',
	Audits nvarchar(max) '$.audits' AS JSON
)As c
CROSS APPLY OPENJSON(c.Audits)
WITH(
	AuditRank int '$.audit_rank',
	Interpretation varchar(258) '$.interpretation',
	Comment varchar(258) '$.comment',
	HasOwner bit '$.has_owner'
) As d
