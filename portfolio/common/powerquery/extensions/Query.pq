section Query;
shared Query.GetQuery=(QueryID as number,EnumSQLQueries as list) as text =>
    let
        p1=List.Select(
            EnumSQLQueries,
            each _{0} = QueryID
        ){0}{1}
    in
        p1;
