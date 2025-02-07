# File Class
Module: FileDetails  
Source: [Get-FileDetails.ps1](./get-filedetails.md)

## Description

Represents an in-memory cache of file attributes.

## Examples
The following example creates an instance of the [File Class](./filedetails.file.md) for each file item found in a collection of directories and subdirectories. The instance is added to a datatable object using the [File.Add(File) Method](./filedetails.file.add.md).

PowerShell
``` powershell
:getEachAncestor1 foreach ($i in $_dirCollection) {
    :getEachParent foreach ($j in Get-ChildItem $i) {
        :getEachFile foreach ($k in Get-ChildItem $j.FullName -File) {
            $x = $k | Select-Object -Property `
            @{l = "Ancestor1"; e = { $i } },
            BaseName,
            CreationTimeUtc,
            DirectoryName,
            Extension,
            FullName,
            LastAccessTimeUtc,
            LastWriteTimeUtc,
            Length;
            $result = [File]::new($x);
            $result.Add($result);
        }
    }
}
```

## Constructors
`File($p1)`&ensp;&ensp;&ensp;&ensp;Initializes a new instance of the [File Class](./filedetails.file.md) with a file object from `System.IO.DirectoryInfo`.

## Fields
`_owner`&ensp;String

The owner of a file is one who may read, write (modify), or execute the file.

## Properties

|Name|Description|
|:--|:--|
|Ancestor1|The recognized first tier of the file directory system hierarchy. Might not be the highest directory in a path.|
|AssignmentPriority|A simplified ranking determined by combinations of AuditRank ranges and the active status of a file.|
|AuditRank|An integer value determined by the relationships of datetime elements, the active status, file extension type, and the detectable presence of a file owner.|
|BaseName|The file name without the extension or URI elements.|
|CreationTimeUtc|The date and time when the file was created.|
|DirectoryName|The full URI to the immediate directory of the file.|
|Extension|The suffix that appears at the end of a file name to indicate the file type.|
|FullName|The full URI of the file.|
|IsActive|A Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date.|
|LastAccessTimeUtc|The date and time in the UTC time zone when the current file was last accessed.|
|LastWriteTimeUtc|The date and time in the UTC time zone when the current file was last written to.|
|Length|Gets the size, in bytes, of the current file.|
|Owner|The user who has full control over the file.|
|Parent|The recognized tier of the file directory system hierarchy immediate to a file.|
|XPK|Hexadecimal representation of the FullName, AuditRank, IsActive, LastAccessTimeUtc, and LastWriteTimeUtc attributes.|

## Methods

|Name|Description|
|:--|:--|
|`File.Add(File)`|Adds an instance of the class to a data table.|
|`File.GetFileOwner(File.FullName)`|Returns the account or name of the file owner from the security descriptor.|
|`File.GetURILastPiece([String])`|Returns the last piece of the AncestorPath value for the Ancestor1 value.|
|`File.SetAuditRank([File],[String])`|Sets the alphabetical value for simplified ranking determined by combinations of AuditRank ranges and the active status of a file.|
|`File.SetIsActive([datetime],[datetime],[datetime])`|Sets a Boolean value based on the relationship of the LastAccess or LastWrite dates with the Creation date and three years prior to the current date.|

## See also

- [File.Add(File) Method](./filedetails.file.add.md)
- [File.GetFileOwner](./filedetails.file.getfileowner.md)
- [File.GetURILastPiece](./filedetails.file.geturilastpiece.md)
- [File.SetAuditRank](./filedetails.file.setauditrank.md)
- [File.SetIsActive](./filedetails.file.setisactive.md)
- [FileCollection Class](./filedetails.filecollection.md)
