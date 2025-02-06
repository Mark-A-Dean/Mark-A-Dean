# File.Add(File) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: [Get-FileDetails.ps1](./get-filedetails.md)

Adds an instance of the class to a data table.

PowerShell
***
``` powershell
Add($q1){Add-File $q1}
```

## Parameters

`q1`&ensp;&ensp;File  
The [File Class](./filedetails.file.md) object to be added to a [FileCollection Class](./filedetails.filecollection.md) datatable object.

## Example

The following example demonstrates how to add an instance of the [File Class](./filedetails.file.md) where the variable `j` stores the current instance of the file metadata properties.

PowerShell  
***
``` powershell
$j|Select-Object -Property `
    @{l="Ancestor1";e={$i}},
    BaseName,
    CreationTimeUtc,
    DirectoryName,
    Extension,
    FullName,
    LastAccessTimeUtc,
    LastWriteTimeUtc,
    Length;
    $result=[File]::new($x);
    $result.Add($result);
```

## Remarks

The method calls the internal function `Add-File([File]$data)` in the [Get-FileDetails](./get-filedetails.md) cmdlet.

## See also

- [File Class](./filedetails.file.md)
- [FileCollection Class](./filedetails.filecollection.md)
- [Get-FileDetails](./get-filedetails.md)
