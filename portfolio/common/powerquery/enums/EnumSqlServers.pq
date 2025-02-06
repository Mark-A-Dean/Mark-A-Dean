let
    EnumSQLInstance=List.Buffer(
        {
            [
                DatabaseName="MyDatabaseOne",
                ServerName="MyDevSQLServerInstance"
            ],
            [
                DatabaseName="MyDatabaseTwo",
                ServerName="MyProductionSQLServerInstance"
            ],
            [
                DatabasenName="EnterpriseViewDatabase",
                ServerName="MyCompanySQLServerInstance"
            ]
        }
    )
in
    EnumSQLInstance meta Metadata.document(
        true,true,
        "Mark A. Dean",
        "A list containing records of SQL Server Instance names and a single database it hosts.",
        "EnumSqlServers",
        "list"
    )
