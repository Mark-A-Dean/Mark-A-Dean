# File.Add(File) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: Get-FileDetails.ps1

Adds an instance of the class to a data table.

PowerShell
***
``` powershell
Add($q1){Add-File $q1}
```

## Parameters

`q1`&ensp;&ensp;File  
The File class object to be added to a FileCollection datatable object.

## Example

The following example demonstrates how to add an instance of the File class where the variable `j` stores the current instance of the file metadata properties.

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

The method calls the internal function `Add-File([File]$data)` in the Get-FileDetails cmdlet.

## See also

- File Class
- FileCollection Class
- Get-FileDetails
