# File.GetFileOwner(File.FullName) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: [Get-FileDetails.ps1](./get-filedetails.md)

Returns the file owner provided by the security descriptor or "No User Account Found" when a value is not found within the security framework.

PowerShell
***
``` powershell
[string]GetFileOwner($q1){
    $x=(Get-Acl $q1).Owner;
    if($x -match "^\w:S"){
        return "No User Account Found";
        }
    else{
        return $x;
    }
}
```

## Parameters

`q1`&ensp;&ensp;FullName  
A string containing the full path of the file.

## Example

The following example shows an abbreviated version of the [File Class](./filedetails.file.md) and its `_owner` field. The class constructor method `File($p1)` stores the output of the `GetFileOwner` function (i.e., the file owner) in the `_owner` field, which then sets the file system Owner class property. If the file owner does not match the pattern: _any alphanumeric character[colon]S_ then "No User Account Found" is returned as the value.

PowerShell  
***
``` powershell
Class File{
    [string] hidden $_owner;
    [string] $Owner;
    File($p1){
        [string]$_owner1=$this.GetFileOwner($p1.FullName);
        $this.Owner=$this._owner;    
    }
}
```

## Remarks
### File owner is empty or whitespace

There are times when the file owner property is empty or whitespace. There are many explanations for why this may occur on the file, notably, a Microsoft Office version might have removed the value. These are intentionally left blank by this method to distinguish them from the the cases of "No User Account Found", which help analysts determine if the file owner no longer is within the system security framework.

### Exceptions

Exceptions raised during the creation of the [File Class](./filedetails.file.md) instance with appear in a pop up window and the [Get-FileDetails](./get-filedetails.md) cmdlet will terminate.

## See also

- [File Class](./filedetails.file.md)
- [Get-Acl](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-acl?view=powershell-7.5)
