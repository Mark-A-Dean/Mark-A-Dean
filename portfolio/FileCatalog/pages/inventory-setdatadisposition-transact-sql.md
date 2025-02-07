# Inventory.SetDataDisposition (Transact-SQL)

**Applies to**: ✔️ SQL Server

`Inventory.SetDataDisposition` is a scalar-valued function that sets the data disposition for a file object in the [Inventory.FileDetails](inventory-filedetails-transact-sql.md) table.

## Syntax

SQL
```sql
Inventory.SetDataDisposition(varchar(140))
```

## Arguments

_varchar(140)_  
A character string representing a space-delimited list element that contains all the file assignment priorities for a given `Parent`.

## Return types

_varchar(20)_  

|Value|Description|
|:--|:--|
|`keep`|One or more values in the Parent's group of assignment priorities is an `A`, `B`, or `C` value.|
|`archive`|One or more values in the Parent's group of assignment priorities is a `D` value.|
|`purge`|One or more values in the Parent's group of assignment priorities is an `E` or `F` value.|

## Remarks

This scalar function is intended only for use within the [`Inventory.ManageFileDetails`](../tsql/procedures/Inventory.ManageFileDetails.sql) stored procedure.

## See also

- [Inventory.FileDetails (Transact-SQL)](./inventory-filedetails-transact-sql.md)
- [Inventory.ManageFileDetails.sql](../tsql/procedures/Inventory.ManageFileDetails.sql)
