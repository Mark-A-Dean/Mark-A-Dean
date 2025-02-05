function New-ExceptionWindow{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [array] $ErrorLog
    )
    begin{
        Add-Type -AssemblyName System.Windows.Forms;
    }
    process{
        $_errorBoxTitle=[string]::Format("Source Data Processing Exception: {0}",$ErrorLog[0]);
        $_errorButtonType=[System.Windows.Forms.MessageBoxButtons]::OK;
        $_errorButtonIcon=[System.Windows.Forms.MessageBoxIcon]::Stop;
        [System.Windows.Forms.MessageBox]::Show($ErrorLog[1],$_errorBoxTitle,$_errorButtonType,$_errorButtonIcon);
        return;
    }
}
