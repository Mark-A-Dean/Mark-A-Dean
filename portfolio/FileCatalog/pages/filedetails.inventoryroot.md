# InventoryRoot Class
Module: FileDetails  
Source: [Get-FileDetails.ps1](./get-filedetails.md)

## Description

Represents an in-memory cache of file attributes specific to a point in the file system where an inventory cycle starts (i.e., _the root_).

## Examples
The following example creates an instance of the `InventoryRoot` class using the `AncestorPath` and `Subdirectory` parameter values. The instance is added to a datatable object using the [InventoryRoot.Add](./filedetails.inventoryroot.add.md) method.

PowerShell
``` powershell
$newRoot=[InventoryRoot]::new(@($AncestorPath,$Subdirectory));
$newRoot.Add($newRoot);
```

## Constructors
`InventoryRoot($p1)`&ensp;&ensp;&ensp;&ensp;Initializes a new instance of the InventoryRoot class with an array object comprised of cmdlet parameter values.

## Properties
|Name|Description|
|:--|:--|
|RootPath|The URI of the file directory supplied as the AncestorPath parameter value in the Get-FileDetails cmdlet.|
|RootDirectoryName|Name of the directory serving as the root.|
|SubdirectoryQuery|A regex expression that provides the type and levels of recursion to the Get-FileDetails cmdlet.|

## Methods
|Name|Description|
|:--|:--|
|`InventoryRoot.Add(File)`|Adds an instance of the class to a data table.|
|`InventoryRoot.GetURILastPiece([array])`|Returns the last node of a URI.|

## Remarks

### Some regex common to SubdirectoryQuery

:bulb: When talking about using regex _match_ is often the verb used for the results. Matches are case-insensitive by default.

|Expression|Interpretation|Parameter usage|
|:--|:--|:--|
|`.*?`|Matches any character (_the unescaped period character_) any number of times (_*_), with as few times to make the match (_?_).|Gets all subdirectories from the root.|
|`\bAlice\b`|Hard matches the term `alice` because of the word-boundary assertions (_the \\-escaped_ `b` _character_).|Specificly targets all root subdirectories named `alice`.|
|`Alice`|Fuzzy matches the term `alice`.|Gets the subdirectories that contain the character pattern `alice`.|
|`Ad-Hoc(?=\sFY)`|Matches `ad-hoc` as long as it is followed by a single space (_the \\-escaped_ `s` _character_) and `fy`. |Queries only the root subdirectories names meeting these criteria.|

## See also

- [Get-FileDetails](./get-filedetails.md)
- [InventoryRoot.Add](./filedetails.inventoryroot.add.md)
- [InventoryRoot.GetURILastPiece](./filedetails.inventoryroot.geturilastpiece.md)
- [InventoryRootCollection Class](./filedetails.inventoryrootcollection.md)
- [Regular expression syntax cheat sheet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions/Cheatsheet)
  
