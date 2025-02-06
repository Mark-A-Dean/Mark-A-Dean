# Get-FileDetails

NameSpace: FileDetails  
Module: FileDetails.psm1  

[PowerShell cmdlet](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7.4) that queries the file system for file metadata and sends it into a SQL Server destination. A subdirectory name is supplied that allows regular expression patterns [^1].

## Syntax

PowerShell
***
``` powershell
Get-FileDetails 
    -AncestorPath <FileInfo>
    -Subdirectory <string>
    -ExcludedItemsSchema <FileInfo>
    -ExcludedItemsFile <FileInfo>
    -SqlServerName <string>
    -SqlDatabaseName <string>
```

## Examples

### Example 1: Get all files in all subdirectories.

The following example uses PowerShell parameter splatting (i.e., a hash table) to query all subdirectories in the directory MyDirectory.

PowerShell
***
``` powershell
$x=@{
    AncestorPath="\\myFileShare.dva.va.gov\MyDirectory\";
    Subdirectory=".*?";
    ExcludedItemsSchema=".\json-schema-excludedItems.json";
    ExcludedItemsFile=".\excludedItems.json";
    SqlServerName="MySqlServerInstance.vha.med.va.gov";
    SqlDatabaseName="MyDatabaseName";
}
Get-FileDetails @x;
```

### Example 2: Get all files in all subdirectories.
The following example will get all files in the subdirectories that matches the term "Ad-Hoc" only as long as it is followed by "[space]FY". Therefore, the following match: 
- Ad-hoc FY18
- Ad-Hoc FY2020
- ad-hoc FY17
- ad-hoc fy2023

Whereas, the following do not match:
- ad-hoc 2023
- adhoc fy2019

PowerShell
***
``` powershell
$x=@{
    AncestorPath="\\myFileShare.gov\MyDirectory\";
    Subdirectory="Ad-Hoc(?=\sFY)";
    ExcludedItemsSchema=".\json-schema-excludedItems.json";
    ExcludedItemsFile=".\excludedItems.json";
    SqlServerName="MySqlServerInstance.gov";
    SqlDatabaseName="MyDatabaseName";
}
Get-FileDetails @x;
```

## Parameters

### AncestorPath  

Supplies the literal path to a file directory locations. The value of **AncestorPath** is used exactly as it is typed. No characters are interpreted as wildcards. Enclose any escape characters in single quotation marks as single quotation marks tell PowerShell to not interpret any characters as escape sequences.

|||
|:--|:--|
|Type|[System.IO.FileInfo]|
|Default value|none|
|Required|True|
|Accept pipeline input|True|
|Script validated|True|

### Subdirectory  

Name of a subdirectory located on a leaft of the ancestor path. May include regular expressions for fuzzy searches or multiple values. Inherent recursion will query all child directories within each subdirectory.

|||
|:--|:--|
|Type|String|
|Default value|none|
|Required|True|

### ExcludedItemsSchema  

Supplies the literal path to a file directory location storing a JSON schema file for a listing of excluded directories and files. The value of **ExcludedItemsSchema** is used exactly as it is typed.

🚧 - this requirement is expected to change over the next versions. The ValidationScript has been disabled. (_PowerShell Core 7.x feature; conflicts with Windows PowerShell 5.1_)

|||
|:--|:--|
|Type|[System.IO.FileInfo]|
|Required|True|
|Accept pipeline input|True|
|Script validated|Not available in Windows PowerShell 5.1|

### ExcludedItemsFile  

Supplies the literal path to a file directory location storing a JSON file listing the excluded directories and files. The value of **ExcludedItemsFile** is used exactly as it is typed.

|||
|:--|:--|
|Type|[System.IO.FileInfo]|
|Required|True|
|Accept pipeline input|True|
|Script validated|Not available in Windows PowerShell 5.1|

### SqlServerName  

The fully qualified domain name of a SQL Server Instance. The ValidatePattern parameter option may be enabled to check that the supplied FQDN matches.

|||
|:--|:--|
|Type|String|
|Default value|none|
|Required|True|
|Pattern validated|True|

### SqlDatabaseName  

The name of the SQL database hosted on **SqlServerName** that stores a base table associated with the [FileCollection Class](./filedetails.filecollection.md).

|||
|:--|:--|
|Type|String|
|Default value|none|
|Required|True|

## Inputs

**String**

You can supply string values for all required parameters.

**System.Collections.Hashtable**

You can pass a hash table (i.e., a dictionary or associative array) with members matching the required parameters into this cmdlet.

## Outputs

**System.Data.DataTable**

The [FileCollection Class](./filedetails.filecollection.md) object that is generated gets passed into the [Update-BaseTable](./update-basetable) cmdlet.

**System.Windows.Forms**

Popup windows contain messages whenever an error exception is encountered.

## See also

- [FileCollection Class](./filedetails.filecollection.md)
- [New-ExceptionWindow](./new-exceptionwindow.md)
- [Update-BaseTable](./update-basetable.md)

## References

[^1]: [Regular expression syntax cheat sheet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions/Cheatsheet)
