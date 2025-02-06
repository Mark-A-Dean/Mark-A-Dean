section Column;
shared Column.GetUnique=(
    ColumnName as text,
    TableName as table,
    StyleFlag as number
) as table =>
    let
        p1=Table.Distinct(
            Table.SelectColumns(TableName,ColumnName)
        ),
        Results=Table.Sort(
            Table.TransformColumns(
                p1,
                {
                    {
                        ColumnName,
                        if StyleFlag = 1 then Text.Upper
                            else if StyleFlag = 2 then Text.Lower
                            else if StyleFlag = 3 then Text.Proper
                            else null
                    }
                }
        ),
        ColumnName
    )
in
    Results Metadata.document(
        false,
        false,
        "Mark A. Dean",
        "Returns the unique values of a specified column. A style can be applied.",
        "Metadata.document",
        "table"
    );
