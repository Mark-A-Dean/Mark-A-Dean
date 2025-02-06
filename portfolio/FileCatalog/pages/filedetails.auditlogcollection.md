# AuditLogCollection Class

## Definition
Namespace: FileDetails  
Module: FileDetails.psm1  
Source: [Get-AuditLog.ps1](./get-auditlog.md)

Creates a table of in-memory data for a file system's file properties.

## Example

The following example creates a .NET datatable object in memory, instantiates it, and assigns it the AuditLogCollection properties necessary for the module.

PowerShell
***
``` powershell
$AuditLogCollection=[System.Data.DataTable]::new();
    [void]$AuditLogCollection.Columns.Add("Auditor",[string]);
    [void]$AuditLogCollection.Columns.Add("CreationTimeUtc",[datetime]);
    [void]$AuditLogCollection.Columns.Add("Description",[string]);
    [void]$AuditLogCollection.Columns.Add("DirectoryName",[string]);
    [void]$AuditLogCollection.Columns.Add("EventDate",[string]);
    [void]$AuditLogCollection.Columns.Add("EventName",[string]);
    [void]$AuditLogCollection.Columns.Add("EventState",[string]);
    [void]$AuditLogCollection.Columns.Add("FullName",[string]);
    [void]$AuditLogCollection.Columns.Add("HashID",[string]);
    [void]$AuditLogCollection.Columns.Add("LastAccessTimeUtc",[datetime]);
    [void]$AuditLogCollection.Columns.Add("LastWriteTimeUtc",[datetime]);
    [void]$AuditLogCollection.Columns.Add("Manifest",[string]);
    [void]$AuditLogCollection.Columns.Add("Parent",[string]);
```

## Remarks

**AuditLogCollection** is a PowerShell object that calls the [.NET DataTable class](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0).

****
[System.Data.DataTable]::new()&ensp;&ensp;Initializes a new instance of the DataTable class with no arguments.

## Properties

|||
|:--|:--|
|Auditor|The Active Directory account of the person who reviewed the files in the current directory.|
|CreationTimeUtc|The date and time when the audit log file was created.|
|Description|An account of the event taken on or in the current directory.|
|DirectoryName|The full URI to the immediate directory of the audit log file.|
|EventDate|The date when the event occurred in `yyyy-mm-dd` format.|
|EventName|The name of the action taken: i.e., _audit_.|
|EventState|The state of the audit; pre-approval, approved, hold, rejected.|
|FullName|The full URI of the audit log file.|
|HashID|Hexadecimal representation of the FullName, CreationTimeUtc, LastAccessTimeUtc, and LastWriteTimeUtc properties.|
|LastAccessTimeUtc|The date and time in the UTC time zone when the audit log file was last accessed.|
|LastWriteTimeUtc|The date and time in the UTC time zone when the audit log file was last written to.|
|Manifest|The audit file contents stored in a compressed JSON format. This column carries a check constraint to ensure a valid JSON structure.|
|Parent|The file directory to the path of BIO team file share. Provides identifying redundancy.|

## Functions and methods

|||
|:--|:--|
|Add-AuditLog([AuditLog]$data)|PowerShell internal function that adds an instance of the [AuditLog](./filedetails.auditlog.md) class to the datatable object.|
|[.NET DataTable Methods](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0#methods)|Methods associated with the .NET DataTable class.|

## Events

|||
|:--|:--|
|Update-BaseTable|PowerShell cmdlet that sends the datatable object into a SQL Server stored procedure as a User-Defined Table Type.|
|[.NET DataTable Events](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable?view=net-8.0#events)||

## See also

- [AuditLog Class](./filedetails.auditlog.md)
- [AuditLog.Add(AuditLog) Method](./filedetails.auditlog.add.md)
- [Get-AuditLog](./get-auditlog.md)
- [Inventory.AuditLog (Transact-SQL)](./inventory-auditlog-transact-sql.md)
- [Update-BaseTable](./update-basetable.md)
