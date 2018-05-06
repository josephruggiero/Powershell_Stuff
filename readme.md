# PowershellStuff
## From Other People
I didn't write this stuff, I'm just using it within my own scripts. I'm not including it in my repo, but I'll post the link to the users
 * [convert-unixtime.ps1](https://github.com/segmentio/unix-time)
 * [Invoke-BalloonTip.ps1](https://github.com/proxb/PowerShell_Scripts) 
 * [Send-Datagram](https://gist.github.com/hotstone/fdff6a808d1e03010d29)
## From Me
* Read-Weather.ps1 - Uses the [Open Weather Map API](https://openweathermap.org) to get the current weater
  * Right now, the weather function assumes that I'm at 1 of 2 possible locations (Milwaukee, WI or Lemont, IL), and chooses the [city ID](http://openweathermap.org/help/city_list.txt) based on my computer's local IP address. For my uses, I already know where I'm going to be most of the time, so this works fine for me. This function can be easily modified to guess your [geolocation based on your public IP](http://ip-api.com/).
* message.ps1 - Creates a ballon tip icon in the system tray (this is just a watered down version of Invoke-BalloonTip.ps1)
* SystemTrayTemperature.ps1 - Creates a System Tray icon that shows the current weather (from the Read-Weather function)
    * This checks every 30 minutes (to not spam the API), and can run as a background task with the task scheduler
 * ScheduledWeather.ps1 - A script that uses the Weather-Read function to get the weather, and send a UDP packet to a [Particle Photon](https://www.particle.io/), which displays the current temperature
 * PlotForecast.ps1 - Checks the open weather map API for the forecast and plots it


