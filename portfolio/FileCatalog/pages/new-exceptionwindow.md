# New-ExceptionWindow

NameSpace: FileDetails  
Module: FileDetails.psm1  

Opens a Windows form on the host system to display an error message.

> This cmdlet when in the **FileDetails** namespace is intended to only be called and executed automatically by custom cmdlets.

## Syntax

PowerShell
***
``` powershell
New-ExceptionWindow -ErrorLog <array>;
```

## Example

The following example captures the line number where an exception halts the [Get-FileDetails](./get-filedetails.md) program execution, formats an error message custom to the error, and then passes that as an two-member array into the cmdlet.

PowerShell
***
``` powershell
$_errorLnNbr=$_.InvocationInfo.ScriptLineNumber;
$_errorMsg=[string]::Format("Exception: Directory collection loading`r`n{0}`r`nLine {1} in executing code.","$_",$_errorLnNbr);
$_errorLog=@("Get-FileDetails",$_errorMsg);
New-ExceptionWindow -ErrorLog $_errorLog;
```

## Parameters

### ErrorLog 

Contains the program name and the message that will appear in the message box when an exception is raised in the program.

|||
|:--|:--|
|Type|array|
|Position|1|
|Default value|Provided by the wrapping cmdlet.|
|Required|True|

## Outputs

[System.Windows.Forms.MessageBox]

## Remarks

This cmdlet was created to replace log files containing errors.

## See also

- [Get-FileDetails](./get-filedetails.md)
