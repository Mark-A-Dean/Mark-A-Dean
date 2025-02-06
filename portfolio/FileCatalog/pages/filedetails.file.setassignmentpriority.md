# File.SetAssignmentPriority([System.Array]) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: [Get-FileDetails.ps1](./filedetails.file.md)

Returns an alphabetical code value determined by the audit rank range and the active status of a file.

PowerShell
***
```powershell
[string]SetAssignmentPriority($p1){
    $results=switch($p1){
        {($p1[0] -gt 8) -eq $true -and $p1[1] -eq $true}{"A";break}
        {(5 -le $p1[0] -and $p1[0] -le 8) -eq $true -and $p1[1] -eq $true}{"B";break}
        {($p1[0] -lt 5) -eq $true -and $p1[1] -eq $true}{"C";break}                    
        {($p1[0] -gt 8) -eq $true -and $p1[1] -eq $false}{"D";break}
        {(5 -le $p1[0] -and  $p1[0] -le 8) -eq $true -and $p1[1] -eq $false}{"E";break}
        {($p1[0] -lt 5) -eq $true -and $p1[1] -eq $false}{"F";break}
        Default{"i"}
    }
    return $results;
}
```

## Parameters

`p1`&ensp;&ensp;`@(_auditRank,_isActive)`  

A zero-based indexed array with members that are evaluated in the function to produce a priority. 

## Example

The following example shows an abbreviated version of the [File Class](./filedetails.file.md). The class's constructor method `File($p1)` contains two variables populated by other functions on which **SetAssignmentPriority** depends. The variables are passed into the function as a single array and the output sets the `AssignmentPriority` property.

PowerShell
***
``` powershell
Class File{
    [string] $AssignmentPriority;
    File($p1){
        [int]$_auditRank=$this.SetAuditRank($p1,$_owner1);
        [bool]$_isActive=$this.SetIsActive($p1.CreationTimeUtc,$p1.LastAccessTimeUtc,$p1.LastWriteTimeUtc);
        $this.AssignmentPriority=$this.SetAssignmentPriority(@($_auditRank,$_isActive));
    }
}
```

## Remarks

The assignment priority extends the ABC analysis prioritization matirx—an inventory management method—using the preceived value of an item as set by rules created by the process management team.

### Logic and interpretations

#### Terms
- **Active**: Determined by the relationship of the date of the last file access or last write with the creation date and three years prior to the current inventory cycle date.
- **Priority**: The relative value of a review based on set of file properties.

|AssignmentPriority|Interpretation|Statement|
|:--:|:--|:--|
|`A`|The audit rank is greater than `8` and the file is active.|These rows have the highest priority and are **T-SQL** code files at ranks greater than `14`.|
|`B`|The audit rank is equal or greater than `5` and less than or equal to `8` and the file is active.|These rows contain active files that are 5 or less years old.|
|`C`|The audit rank is less than `5` and the file is active.|These are active files, but are 5 years or older.|
|`D`|The audit rank is greater than `8` and the file is inactive.|These rows have midlevel priority and are **T-SQL** code files at ranks greater than `14`.|
|`E`|The audit rank is equal or greater than `5` and less than or equal to `8` and the file is inactive.|These rows contain inactive files that are 5 or less years old.|
|`F`|The audit rank is less than `5` and the file is inactive.|These inactive files have the lowest need for a review.|

## See also

- [File Class](./filedetails.file.md)
- [File.SetAuditRank](./filedetails.file.setauditrank.md)
- [File.SetIsActive](./filedetails.file.setisactive.md)
