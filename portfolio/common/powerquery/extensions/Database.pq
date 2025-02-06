section Database;
    shared Database.ExecuteWithResults=(
        ServerName as text,
        DatabaseName as text,
        Query as text
    ) as table =>
    let
        _source=Sql.Database(
            ServerName,
            DatabaseName,
            [
                MaxDegreeOfParallelism=4,
                CommandTimeout=#duration(0,0,3,0),
                ConnectionTimeout=#duration(0,0,0,30)
            ]
	),
        Results=Value.NativeQuery(
            _source,Query,null,[EnableFolding=true]
        )
    in
        Results Metadata.document(
        false,
        false,
        "Mark A. Dean",
        "Database.ExecuteWithResult sets a database connection and executes a TSQL query.",
        "Metadata.document",
        "table"
    );
