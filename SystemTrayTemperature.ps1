# Notification Script : https://stackoverflow.com/questions/24363179/can-powershell-put-counter-values-in-the-system-tray?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
### I didn't end up using the sources below, but it's still worth referencing
### incase I need them later
# Numbers Icons 1-100   :  https://mapicons.mapsmarker.com/numbers-letters/numbers/
# Notifification source :  https://www.reddit.com/r/PowerShell/comments/77gl4t/display_key_info_in_system_tray/

## directly copy pasted from the top link. I needed a way of generating an ICO
## file for numbers. This method was a lot easier.

Add-Type -ReferencedAssemblies @("System.Windows.Forms"; "System.Drawing") -TypeDefinition @"
    using System;
    using System.Drawing;
    using System.Windows.Forms;
    public static class TextNotifyIcon
    {
        // it's difficult to call DestroyIcon() with powershell only...
        [System.Runtime.InteropServices.DllImport("user32")]
        private static extern bool DestroyIcon(IntPtr hIcon);

        public static NotifyIcon CreateTrayIcon()
        {
            var notifyIcon = new NotifyIcon();
            notifyIcon.Visible = true;

            return notifyIcon;
        }

        public static void UpdateIcon(NotifyIcon notifyIcon, string text)
        {
            using (var b = new Bitmap(16, 16))
            using (var g = Graphics.FromImage(b))
            using (var font = new Font(FontFamily.GenericMonospace, 8))
            {
                g.DrawString(text, font, Brushes.Black, 0, 0);

                var icon = b.GetHicon();
                try
                {
                    notifyIcon.Icon = Icon.FromHandle(icon);
                } finally
                {
                    DestroyIcon(icon);
                }
            }
        }
    }
"@
$icon=[TextNotifyIcon]::CreateTrayIcon()


$waitTimeMin=30 #time between updating the temperature, in minutes.
$waitTimeSec=$waitTimeMin * 60


## Run this part indefinitely, but wait for 10 minutes between executions
while ($true){
	# Use my read-weather function to get the weather
	$data=Read-Weather
	if ($data.Name) {# If the name function exists, the the function called correctly
		$tempF=$data.main.temp
		$text = [math]::round($tempf)
		[TextNotifyIcon]::UpdateIcon($icon, $text)
	}
	# Don't try to update the icon if read fails
	[console]::beep(1000,1000)
	start-sleep $waitTimeSec #Attempts to read again after $waitTime minutes.
}