# FileCollection Class

## Definition
Namespace: FileDetails  
Module: FileDetails.psm1  
Source: Get-FileDetails.ps1

Creates a table of in-memory data for a file system's file properties.

## Example

The following example creates a .NET datatable object in memory, instantiates it, and assigns it the FileCollection properties necessary for the module.

PowerShell
***
``` powershell
$FileCollection=[System.Data.DataTable]::new();
    [void]$FileCollection.Columns.Add("Ancestor1",[string]);
    [void]$FileCollection.Columns.Add("AssignmentPriority",[string]);
    [void]$FileCollection.Columns.Add("AuditRank",[int]);
    [void]$FileCollection.Columns.Add("BaseName",[string]);
    [void]$FileCollection.Columns.Add("CreationTimeUtc",[datetime]);
    [void]$FileCollection.Columns.Add("DirectoryName",[string]);
    [void]$FileCollection.Columns.Add("Extension",[string]);
    [void]$FileCollection.Columns.Add("FullName",[string]);
    [void]$FileCollection.Columns.Add("IsActive",[bool]);
    [void]$FileCollection.Columns.Add("LastAccessTimeUtc",[datetime]);
    [void]$FileCollection.Columns.Add("LastWriteTimeUtc",[datetime]);
    [void]$FileCollection.Columns.Add("Length",[int]);
    [void]$FileCollection.Columns.Add("Owner",[string]);
    [void]$FileCollection.Columns.Add("Parent",[string]);
    [void]$FileCollection.Columns.Add("XPK",[string]);
```

## Remarks

FileCollection is a PowerShell object that calls the [.NET DataTable class](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0). It is associated with the PowerShell function Add-File(), which serves as a method that populates the table with data from instances of the File Class.

### XPK and HashID

🔍 The property `XPK` is renamed as `HashID` in the relatable SQL Server objects.

## Constructors

[System.Data.DataTable]::new()&ensp;&ensp;Initializes a new instance of the DataTable class with no arguments.

## Properties

|||
|:--|:--|
|Ancestor1|The recognized first tier of the file directory system hierarchy. Might not be the highest directory in a path.|
|AssignmentPriority|A simplified ranking determined by combinations of AuditRank ranges and the active status of a file.|
|AuditRank|An integer value determined by the relationships of datetime elements, the active status, file extension type, and the detectable presence of a file owner.|
|BaseName|The file name without the extension or URI elements.|
|CreationTimeUtc|The date and time when the file was created.|
|DirectoryName|The full URI to the immediate directory of the file.|
|Extension|The suffix that appears at the end of a file name to indicate the file type.|
|FullName|The full URI of the file.|
|XPK|Hexadecimal representation of the FullName, AuditRank, IsActive, LastAccessTimeUtc, and LastWriteTimeUtc attributes.|
|IsActive|A Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date.|
|LastAccessTimeUtc|The date and time in the UTC time zone when the current file was last accessed.|
|LastWriteTimeUtc|The date and time in the UTC time zone when the current file was last written to.|
|Length|Gets the size, in bytes, of the current file.|
|Owner|The user who has full control over the file.|
|Parent|The recognized tier of the file directory system hierarchy immediate to a file.|

## Functions and methods

|||
|:--|:--|
|Add-File([File]$data)|PowerShell internal function that adds an instance of the File class to the datatable object.|
|[.NET DataTable Methods](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0#methods)||

## Events

|||
|:--|:--|
|Update-BaseTable|PowerShell cmdlet that sends the datatable object into a SQL Server stored procedure as a User-Defined Table Type.|
|[.NET DataTable Events](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0#events)||

## See also

- File Class
- File.Add(File) Method
- FileCollection.AuditRank Property
- FileCollection.IsActive Property
- Get-FileDetails
- Inventory.FileDetails (Transact-SQL)
