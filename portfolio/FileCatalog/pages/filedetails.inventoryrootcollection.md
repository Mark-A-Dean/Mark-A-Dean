# InventoryRootCollection Class

## Definition
Namespace: FileDetails  
Module: FileDetails.psm1  
Source: [Get-FileDetails.ps1](./get-filedetails.md)

Creates a table of in-memory data for some of a file system's file properties.

## Example

The following example creates a .NET datatable object in memory, instantiates it, and assigns it the InventoryRootCollection properties necessary for the module.

PowerShell
***
``` powershell
$InventoryRootCollection=[System.Data.DataTable]::new();
  [void]$InventoryRootCollection.Columns.Add("RootPath",[string]);
  [void]$InventoryRootCollection.Columns.Add("RootDirectoryName",[string]);
  [void]$InventoryRootCollection.Columns.Add("SubdirectoryQuery",[string]);
```

## Remarks

InventoryRootCollection is a PowerShell object that calls the [.NET DataTable class](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0). It is associated with the internal PowerShell function `Add-InventoryRoot()`, which serves as a method that populates the table with data from instances of the [InventoryRoot Class](./filedetails.inventoryroot.md).

## Constructors

[System.Data.DataTable]::new()&ensp;&ensp;Initializes a new instance of the DataTable class with no arguments.

## Properties

|||
|:--|:--|
|RootPath|The URI of the file directory supplied as the AncestorPath parameter value in the Get-FileDetails cmdlet.|
|RootDirectoryName|Name of the directory serving as the root.|
|SubdirectoryQuery|A regex expression that provides the type and levels of recursion to the Get-FileDetails cmdlet.|

## Functions and methods

|||
|:--|:--|
|Add-InventoryRoot([InventoryRoot]$data)|PowerShell internal function that adds an instance of the [InventoryRoot Class](./filedetails.inventoryroot.md) to the datatable object.|
|[.NET DataTable Methods](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0#methods)||

## Events

|||
|:--|:--|
|Update-BaseTable|PowerShell cmdlet that sends the datatable object into a SQL Server stored procedure as a User-Defined Table Type.|
|[.NET DataTable Events](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0#events)||

## See also

- [InventoryRoot Class](./filedetails.inventoryroot.md)
- [InventoryRoot.Add(File) Method](./filedetails.inventoryroot.add.md)
- [Get-FileDetails]([Get-FileDetails.ps1](./get-filedetails.md)
- [Update-BaseTable](./update-basetable.md)
- [Inventory.FileDetailsRoot (Transact-SQL)](./inventory-filedetailsroot-transact-sql.md)
