let
//A list of TSQL queries.
    EnumSqlQueries=List.Buffer(
        {
            {
                1,
                "SELECT TOP 10 i.Ancestor1,i.Extension,i.CreationTimeUtc,
                i.LastAccessTimeUtc,i.LastWriteTimeUtc,i.Length As [Size(KB)]
                ,i.HashID FROM DOEx.vw_FileDetails As i",
                "Get-FileDetails"
            },
            {
                2,
                Text.Format(
                    "SELECT a.Ancestor1,a1.Extension,a1.CreationTimeUtc,
                    a1.LastAccessTimeUtc,a1.LastWriteTimeUtc,a1.Length As [Size(KB)],
                    a1.HashID--,SUM(a1.Length)OVER(Partition By a.Ancestor1)As Subtotal
                    FROM(
                        SELECT Ancestor1 FROM DOEx.vw_FileDetails
                        GROUP BY Ancestor1
                    ) As a
                    CROSS APPLY(
                        SELECT TOP (#{0}) i.Extension,i.CreationTimeUtc,i.LastAccessTimeUtc,
                        i.LastWriteTimeUtc,i.Length,i.HashID,i.Parent,i.Owner
                        FROM DOEx.vw_FileDetails As i
                        WHERE i.Ancestor1=a.Ancestor1
                    ) As a1",
                    {TopN}
                ),
                "Get-TopNByAncestor1"
            },
            {
                3,
                "SELECT Extension FROM DOEx.vw_FileDetails GROUP BY Extension",
                "Get-UniqueFileExtensions"
            }
        }
    )
in
    EnumSqlQueries meta Metadata.document(
        true,true,
        "Mark A. Dean",
        "A list containing lists of T-SQL scripts identified with an integer in each list's first member.",
        "EnumSqlQueries",
        "list"
    )
