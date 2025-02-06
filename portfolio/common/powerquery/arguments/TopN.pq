50 meta Metadata.document(
        true,true,
        "Mark A. Dean",
        "Used in conjuction with Text.Format. Set the row limit of a TSQL query result set to a specified number of rows or percentage.",
        "TopN",
        "number",
        {
                [
                        Description="Format a string to limit TSQL results by a TopN value.",
                        Code="--when TopN is set with the value of 50 "& Character.FromNumber(10)&"Text.Format(SELECT TOP (#{0}) [...] FROM MyTable"",{TopN})",
                        Result="SELECT TOP 50 FROM MyTable"
                ]
        }
)
