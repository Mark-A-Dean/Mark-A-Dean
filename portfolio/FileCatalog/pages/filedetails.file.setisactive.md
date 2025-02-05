# File.SetIsActive([datetime],[datetime],[datetime]) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: Get-FileDetails.ps1

Sets the IsActive property value by assessing the relationships between three file datetime properties.

PowerShell
***
```powershell
[bool]SetIsActive($p0,$p1,$p2){
    [datetime]$px=(Get-Date).AddYears(-3);
    $results=switch($px){
        {$p0 -gt $_ }{$true;break}
        {$p1 -gt $p0 -and $p1 -gt $_}{$true;break}
        {$p2 -gt $p0 -and $p2 -gt $_}{$true;break}
        Default{$false}
    }
    return $results;
}
```

## Parameters

`p0`&ensp;&ensp;`datetime`  
**CreationTimeUtc**:&ensp;&ensp;The date and time when the file was created.

`p1`&ensp;&ensp;`datetime`  
**LastAccessTimeUtc**:&ensp;&ensp;The date and time in the UTC time zone when the file was last accessed.

`p2`&ensp;&ensp;`datetime`  
**LastWriteTimeUtc**:&ensp;&ensp;The date and time in the UTC time zone when the file was last written to.

## Example

The following example shows an abbreviated version of the File Class. The class constructor method `File($p1)` contains a variable _isActive_ that stores the value from the method. This variable sets the `IsActive` property on the current instance of the class and serves as a parameter on other class methods.

PowerShell
***
``` powershell
Class File{
    [bool] $IsActive;
    File($p1){
        [bool]$_isActive=$this.SetIsActive($p1.CreationTimeUtc,$p1.LastAccessTimeUtc,$p1.LastWriteTimeUtc);
        $this.IsActive=$_isActive;
    }
}
```

## Remarks

## See also
- File Class
- FileCollection.IsActive Property
