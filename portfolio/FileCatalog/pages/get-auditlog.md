# Get-AuditLog

NameSpace: FileDetails  
Module: FileDetails.psm1  

A [PowerShell cmdlet](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7.4) that queries the file system for **audit log** file metadata and sends it into a SQL Server destination. A subdirectory name is supplied that allows regular expression patterns [^1].

## Syntax

PowerShell
***
``` powershell
Get-GetAuditLog
    -AncestorPath <FileInfo>
    -Subdirectory <string>
    -SqlServerName <string>
    -SqlDatabaseName <string>
```

## Description

## Examples

### Example 1: Get all files in all subdirectories.

The following example uses PowerShell parameter splatting (i.e., a hash table) to query all subdirectories in the directory MyDirectory.

PowerShell
***
``` powershell
$x=@{
    AncestorPath="\\myFileShare\MyDirectory\";
    Subdirectory=".*?";
    SqlServerName="MySqlServerInstance";
    SqlDatabaseName="MyDatabaseName";
}
Get-AuditLog @x;
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
    AncestorPath="\\myFileShare\MyDirectory\";
    Subdirectory="Ad-Hoc(?=\sFY)";
    SqlServerName="MySqlServerInstance";
    SqlDatabaseName="MyDatabaseName";
}
Get-AuditLog @x;
```

## Parameters

### AncestorPath  

Supplies the literal path to a file directory locations. The value of **AncestorPath** is used exactly as it is typed. No characters are interpreted as wildcards. Enclose any escape characters in single quotation marks as single quotation marks tell PowerShell to not interpret any characters as escape sequences.

|||
|:--|:--|
|Type|[System.IO.FileInfo]|
|Position|1|
|Default value|none|
|Required|True|
|Accept pipeline input|True|
|Script validated|True|

### Subdirectory  

Name of a subdirectory located on a leaf of the ancestor path. May include regular expressions for fuzzy searches or multiple values. Inherent recursion will query all child directories within each subdirectory.

|||
|:--|:--|
|Type|String|
|Position|2|
|Default value|none|
|Required|True|

### SqlServerName  

The fully qualified domain name of a SQL Server Instance. The ValidatePattern parameter option may be enabled to check that the supplied FQDN matches.

|||
|:--|:--|
|Type|String|
|Position|3|
|Default value|none|
|Required|True|
|Pattern validated|True|

### SqlDatabaseName  

The name of the SQL database hosted on **SqlServerName** that stores a base table associated with the FileCollection Class.

|||
|:--|:--|
|Type|String|
|Position|4|
|Default value|none|
|Required|True|

## Inputs

**String**

You can supply string values for all required parameters.

**System.Collections.Hashtable**

You can pass a hash table (i.e., a dictionary or associative array) with members matching the required parameters into this cmdlet.

## Outputs

**System.Data.DataTable**

The FileCollection class object that is generated gets passed into the **Update-BaseTable**.

**System.Windows.Forms**

Popup windows contain messages whenever an error exception is encountered.

## See also

* AuditLog Class
* AuditLogCollection Class
* Inventory.AuditLog (Transact-SQL)
* New-ExceptionWindow
* Update-BaseTable

## References

[^1]: [Regular expression syntax cheat sheet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions/Cheatsheet)
