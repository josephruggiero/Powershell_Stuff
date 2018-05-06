function message {
Param(
[Parameter(Mandatory=$true)][string]$message
)

Add-Type -AssemblyName  System.Windows.Forms
$global:balloon = New-Object System.Windows.Forms.NotifyIcon

$path = (Get-Process -id $pid).Path
$balloon.Icon  = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Warning
$balloon.BalloonTipText  = "joe"
$balloon.Visible  = $true
$balloon.ShowBalloonTip(150)

}