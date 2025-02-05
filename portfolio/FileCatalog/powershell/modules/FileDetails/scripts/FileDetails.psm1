# Experience proved that including these first two lines helps with overall execution. -Reduces whoops!
[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");
Add-Type -AssemblyName System.Windows.Forms;
Get-ChildItem -Path "\powershell\modules\FileDetails\functions"|ForEach-Object -Process {
    . $PSItem.FullName;
}
