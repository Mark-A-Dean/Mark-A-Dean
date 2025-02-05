# File.SetAuditRank([File],[String]) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: Get-FileDetails.ps1

Sets the AuditRank property value by assessing the relationships between three file datetime properties, the file extension, and the presence of a file owner.

PowerShell
***
```powershell
[int]SetAuditRank($p1,$p2){
    $currentDate=Get-Date;
    $d0=$p1.CreationTimeUtc.ToString("yyyy-MM-dd");
    $d1=$p1.LastAccessTimeUtc.ToString("yyyy-MM-dd");
    $d2=$p1.LastWriteTimeUtc.ToString("yyyy-MM-dd");
    $validDate=if($p1.CreationTimeUtc -gt ($currentDate).AddYears(-5)`
        -and $p1.CreationTimeUtc -lt $currentDate){$true}else{$false};
    $x=switch($p1){
        {$validDate -eq $true}{5}
        {$d0 -eq $d1 -and $d1 -eq $d2 -and $validDate -eq $true}{6}
        {$d0 -eq $d1 -and $d1 -eq $d2 -and $validDate -eq $false}{11}
        {$_.Extension -eq ".sql"}{2}
        {$p2 -eq "No User Account Found"}{2}
        {[string]::IsNullOrWhiteSpace($p2)}{1}
        Default {0}
    } 
    return ($x|Measure-Object -Sum).Sum;
}
```

## Parameters

`p1`&ensp;&ensp;File  
The current instance of the file. Provides the values of `CreationTimeUtc`, `LastAccessTimeUtc`, `LastWriteTimeUtc`, and `Extension` to the method.

`p2`&ensp;&ensp;String  
The file owner provided by the File class method **GetFileOwner**. This value is not a member of the current _File_ instance and must be obtained separately.

## Example

The following example shows an abbreviated version of the File Class. The class constructor method `File($p1)` contains a variable `_auditRank` that stores the value from the method. This variable sets the `AuditRank` property and serves as a parameter on other class methods.

PowerShell
***
``` powershell
Class File{
    [int] $AuditRank;
    File($p1){
        [int]$_auditRank=$this.SetAuditRank($p1,$_owner1);
        $this.AuditRank=$_auditRank;
    }
}
```

## Remarks

### Value accumulation

A value assignment is added to the total for each condition that is truthfully met. For example, if a file:

- was created within the last 5 years from the most recent inventory date: `5`,
- there has been no recorded activity: `6`,
- the file extension is `.sql`: `2`, and
- there is no owner found in the VA security system: `2`.

**AuditRank** = `5+6+2+2=15`

> _15_: This is interpreted as: "Review this important (tsql code) file for authenticity and validity before files having a lower audit rank."

### Datetime as dates

Datetime values are converted to their repective date only forms to remove unneeded specificity in value comparisons.

## See also

- File Class
- File.GetFileOwner
- FileCollection.AuditRank
