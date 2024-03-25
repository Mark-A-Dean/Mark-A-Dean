---
name: New SQL Object
about: Create or modify a T-SQL Database Object.
title: SchemaName.ObjectName
labels: good first issue
assignees: ''

---

Creator :  "Person or entity who created the item."
Description: "An account of the item."
Replaces: "1.0.0"
Identifier: "BIO_NetworkGraph.Graph"
IsReplacedBy: null
Status: "Superseded, Steady, Start, Obsolete, Deleted"
State: "Rejected, Pre-Approval, Hold, Approved'"
ResourceType: "TABLE, VIEW, TYPE, PROCEDURE, FUNCTION"
Title: "BIO_NetworkGraph.Graph.NAME"
Version: "1.0.1"
Columns:
``` json
[
    {"Name":"HashID","Description":"Hexadecimal representation of attribute values that uniquely identifies the row instance separately or in combination with other elements."},
    {"Name":"RowModifiedDateTime","Description":"The date and time in the UTC time zone when the row was last modified."}
]
```
Parameters:
``` json
[ 
    {"Name":"@dt","Description":"READONLY table-valued parameter of the Graph.DT_TYPE type."}
]
```
