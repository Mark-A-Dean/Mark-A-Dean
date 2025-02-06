# AuditLog.Add(AuditLog) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: [Get-AuditLog.ps1](./get-auditlog.md)

Adds an instance of the class to a data table.

PowerShell
***
``` powershell
Add($q1){Add-AuditLog $q1}
```

## Parameters

`q1`&ensp;&ensp;AuditLog  
The AuditLog class object to be added to a [AuditLogCollection](./filedetails.auditlogcollection.md) datatable object.

## Example

The following example shows how to add an instance of the [AuditLog](./filedetails.auditlog.md) class where the variable `j` stores the current instance of the file metadata properties. `j` is reassigned with a `Select-Object` of itself to ensure the required properties are recorded in the resultant `PSObject`. When the file extension is `.log` a new PSObject, `x`, is created that includes a calculated single property which contains the file contents, `Content`. Lastly, `x` is used to construct a new instance of the `AuditLog` class and that is added to a datatable object with the class's `Add` method.

PowerShell  
***
``` powershell
 $j=$j|Select-Object -Property Attributes,CreationTimeUtc,DirectoryName,Extension,FullName,LastAccessTimeUtc,LastWriteTimeUtc;
 if($j.Extension -eq ".log"){
    $x=Get-Item $j.FullName|Select-Object -Property `
    @{
        l="Content";
        e={
            Get-Content $j.FullName|ConvertFrom-Json;
        }
    },
    CreationTimeUtc,
    DirectoryName,
    FullName,
    LastAccessTimeUtc,
    LastWriteTimeUtc
    $result=[AuditLog]::new($x);
    $result.Add($result);
}
```

## Remarks

The method calls the internal function `Add-AuditLog([AuditLog]$data)` in the [Get-AuditLog](./get-auditlog.md) cmdlet.

## See also

- [AuditLog Class](./filedetails.auditlog.md)
- [AuditLogCollection Class](./filedetails.auditlogcollection.md)
- [Get-AuditLog](./get-auditlog.md)
