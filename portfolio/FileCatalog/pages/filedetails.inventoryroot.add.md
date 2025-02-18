# InventoryRoot.Add(File) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: [Get-FileDetails.ps1](./get-filedetails.md)

Adds an instance of the class to a data table.

PowerShell
***
``` powershell
Add($q1){Add-InventoryRoot $q1;}
```

## Parameters

`q1`&ensp;&ensp;InventoryRoot  
The [InventoryRoot Class](./filedetails.inventoryroot.md) object to be added to a [InventoryRootCollection](./filedetails.inventoryrootcollection.md) datatable object.

## Example

The following example adds an instance of the _InventoryRoot Class_ to the datatable object. The variable `newRoot` stores a new class instance constructed from the members of an array that are the values of the `AncestorPath` and `Subdirectory` cmdlet parameters. Then the variable accesses the `Add()` function to complete the action.

PowerShell  
***
``` powershell
$newRoot=[InventoryRoot]::new(@($AncestorPath,$Subdirectory));
$newRoot.Add($newRoot);
```

## Remarks

The method calls the internal function `Add-InventoryRoot([InventoryRoot]$data)` in the [Get-FileDetails](./get-filedetails.md) cmdlet.

## See also

- [Get-FileDetails](./get-filedetails.md)
- [InventoryRoot Class](./filedetails.inventoryroot.md)
- [InventoryRoot.GetURILastPiece](./filedetails.inventoryroot.geturilastpiece.md)
- [InventoryRootCollection](./filedetails.inventoryrootcollection.md)
