# AuditLog Class
Module: FileDetails  
Source: Get-AuditLog.ps1

## Description

Represents an in-memory cache of file attributes.

## Examples
The following example creates an instance of the AuditLog class for each audit log file (`audit.log`) item found in a collection of directories and subdirectories. The instance is added to a datatable object using the [AuditLog.Add](#) method.

PowerShell
``` powershell
:getEachAncestor1 foreach($i in $_dirCollection){
    :getEachParent foreach($j in (Get-ChildItem $i)){
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
    }
}
```

## Constructors

`AuditLog([PSObject])`&ensp;&ensp;&ensp;&ensp;Initializes a new instance of the AuditLog class with a file object taken from `System.IO.DirectoryInfo`.

## Fields

`d0`, `d1`, and `d2` &ensp;String

These fields respectively convert the CreationTimeUtc, LastAccessTimeUtc, and LastWriteTimeUtc datetime values to `yyyy-MM-dd` to avoid possible NULL exceptions.

## Properties
|Name|Description|
|:--|:--|
|Auditor|The Active Directory account of the person who reviewed the files in the current directory.|
|CreationTimeUtc|The date in `yyyy-mm-dd` format when the file was created.|
|Description|An account of the event.|
|DirectoryName|The full URI to the immediate directory of the audit log file.|
|EventDate|The date when the event occurred in `yyyy-mm-dd` format.|
|EventName|The name of the action taken: i.e., Audit.|
|EventState|The state of the audit; pre-approval,approved,hold,rejected.|
|FullName|The full URI of the file.|
|HashID|Hexadecimal representation of the FullName, CreationTimeUtc, LastAccessTimeUtc, and LastWriteTimeUtc properties.|
|LastAccessTimeUtc|The date in `yyyy-mm-dd` format when the current audit log file was last accessed.|
|LastWriteTimeUtc|The date in `yyyy-mm-dd` format when the current audit log file was last written to.|
|Manifest|The audit file contents stored in a compressed JSON format|
|Parent|The file directory to the path of BIO team file share. Provides identifying redundancy.|

## Methods
|Name|Description|
|:--|:--|
|`AuditLog.Add(AuditLog)`|Adds an instance of the class to a data table.|
|`AuditLog.ConvertManifest(Audit.Content.manifest)`|Converts the contents of the audit log to a compressed JSON format.|

## See also

- AuditLog.Add(AuditLog) Method
- AuditLogCollection Class
- Get-AuditLog
