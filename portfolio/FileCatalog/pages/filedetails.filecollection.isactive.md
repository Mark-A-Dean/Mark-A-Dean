# FileCollection.IsActive Property

## Definition

Namespace: FileDetails  
Module: FileDetails  
Source: [Get-FileDetails.ps1](./get-filedetails.md) 

A Boolean value based on the relationship of the _LastAccess_ or _LastWrite_ dates with the _Creation_ date and three years prior to the current date. This value is set by the [File Class](./filedetails.file.md) [File.SetIsActive](./filedetails.file.setisactive.md) method.

PowerShell
***
``` powershell
[bool] $IsActive {File.SetIsActive($p0,$p1,$p2)}
```

## Property value

Boolean

|Value|Logic|
|:--:|:--|
|0|No conditions were met to set the property as `true`. This is also the default value.[^1]|
|1|The file `CreationTimeUtc` attribute value occurs within the past 3 years from [_Today_](#terms).|
|1|The file `LastAccessTimeUtc` attribute is more recent than the `CreationTimeUtc` attribute and three years prior to _Today_.|
|1|The file `LastWriteTimeUtc` attribute is more recent than the `CreationTimeUtc` attribute and three years prior to _Today_.|

## Remarks

Although rare, file system administrations can affect the metadata. For example, a file write date can occur before a create date.

### Terms

- **_Today_**: the current system datetime of when the inventory capture was made. This means that the audit rank will vary across multiple executions. Check the `RowModifiedDateTime` and the table's extended property for more date information. 

## See also

- [File Class](./filedetails.file.md)
- [File.SetIsActive](./filedetails.file.setisactive.md)
- [FileCollection Class](./filedetails.filecollection.md)

## Notes
[^1]: When one condition is met, then the value of `true` is assigned to the property for the file.
