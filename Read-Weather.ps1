#URL for the weather API
function Read-weather {

# Gets the IP address of the PC, and adjusts parameters based on that:
$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1} 
$ip.ipaddress[0] 
# From : https://blogs.technet.microsoft.com/heyscriptingguy/2014/04/10/powertip-use-powershell-to-get-ip-addresses/

if ($address = "REMOVED") { #If I'm in Lemont, use this City ID
	$cityID="REMOVED"
	$cityname = "REMOVED"
} else { #Otherwise, assume I'm in "REMOVED"
	$cityID="REMOVED"
	$cityname = "REMOVED"
}
<#
It is possible to modify this to estimate a geolocation based on the public IP address. Some useful APIs you could use are: 
https://api.ipdata.co/
https://www.ipify.org/
http://ip-api.com/json
#>



$url="http://api.openweathermap.org/data/2.5/weather?"

#$APIkey="&APPID=YOUR-API-KEY-HERE" #(I have mine saved in my $profile, so I don't need to get in in this script
$units="imperial"
$fullURL=$url + `
		"id=" + $cityID + `
				"&APPID=" + $APIkey + `
				"&units=" + $units #Put all the API parts together
#Read from url
$webread=invoke-webrequest $fullURL
$data=convertfrom-json $webread.content


#Get the temperature and convert to F


if ($data.Name ) { #Make sure the city name is present, to verify that the api was read correctly
	$tempF=$data.main.temp
	$tempMinF=$data.main.temp_min
	$tempMaxF=$data.main.temp_max
	$humidity=$data.main.humidity
	echo "$tempMinf degrees F (min)"
	echo "$tempf degrees F"
	echo "$tempMaxf degrees F (max)"
	echo "$humidity% humidity"
} else {
	$data = "Unable to read temperature for $cityname"
}

return $data
}