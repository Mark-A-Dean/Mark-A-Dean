# File.GetURILastPiece([String]) Method

## Definition

Namespace: FileDetails  
Module: FileDetails.psm1  
Source: Get-FileDetails.ps1

Returns the last node (also _piece_ when used of a `string` value) of a Uniform Resource Identifier (URI) using a Regular Expression (regex) operation[^1].

PowerShell
***
``` powershell
[string]GetURILastPiece($q1){
    $regexOptions=[Text.RegularExpressions.RegexOptions]"IgnoreCase, CultureInvariant";
    $_uriPieceMatch="[^\\]+\\?$";
    $x=([Regex]::Match($q1,$_uriPieceMatch,$regexOptions).Value).Replace("\","");
    return $x;
}
```

## Parameters

`p1`&ensp;&ensp;String  

A URI to be parsed. The URI is the full file path down to a specific directory.

|URI|Type|Description|
|:--|:--|:--|
|**Ancestor1**|`[System.IO.FileInfo]`|This path is supplied by the first parameter on the Get-FileDetails.ps1 cmdlet.|
|**Parent**|`string`|Full file path to the immediate directory where the file is located.|

## Example

The following example shows an abbreviated version of the File Class. The class constructor method `File($p1)` sets two properties: `Ancestor1` and `Parent` by calling the function and passing in URIs for parsing. `Ancestor1` is added into the class object as a custom property.

PowerShell
***
``` powershell
Class File{
    [string] $Ancestor1;
    [string] $Parent;
    File($p1){
        $this.Ancestor1=$this.GetURILastPiece($p1.Ancestor1);
        $this.Parent=$this.GetURILastPiece($p1.DirectoryName);
    }
}
```

## Remarks

### Pattern match

`"[^\\]+\\?$"`&ensp;&ensp;Matches the end of the string if it contains at least one character that is not a backslash, but is optionally preceded by a backslash.

The method returns the value of the match and replaces a trailing backslash characters with an empty string should one occur (more typical of _Ancestor1_ URIs than _Parent_).

### Regular expression options
Regex options are parameters that control the behavior of a regular expression[^1]. The GetURILastPiece method passes two options.

|Option|Description|
|:--|:--|
|`IgnoreCase`|Case sensitivity is disabled for the match.|
|`CultureInvariant`|Cultural language differences are disabled for the match.|

## See also

- File Class

## References
[^1]: [RegexOptions Enum](https://learn.microsoft.com/en-us/dotnet/api/system.text.regularexpressions.regexoptions?view=net-8.0)
