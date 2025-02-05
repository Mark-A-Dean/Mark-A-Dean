function New-HashID{
<#
.DESCRIPTION
    ** ALERT: FUNCTION NOT INTENDED FOR SECURITY ENCRYPTION PURPOSES **
    Converts a string value into a hexadecimal hash value that may be used as 
    a globally unique identifier (GUID).
.PARAMETER
    The parameter p1 is a string value that converted to a hexadecimal hash 
    value.
.EXAMPLE
    $a="alice";$b="bob";
    New-HashID( ($a,$b -join"^"));
    Output: 63BDF6121899006E5313EB916EC961515EE9E8289A5EF5F99D1901DD7B09ADE1
    
    New-HashID converts the concatenation into its hexadecimal value.
    The p1 parameter must be a string value.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$p1
    )
    process{
        $paramStream = [System.IO.MemoryStream]::new();
        $streamWriter = [System.IO.StreamWriter]::new($paramStream);
        $streamWriter.Write($p1);
        $streamWriter.Flush();
        $paramStream.Position = 0;
        return (Get-FileHash -InputStream $paramStream -Algorithm SHA256).Hash;
    }
}
