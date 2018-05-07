# Gets the IP address of the PC, and adjusts parameters based on that:
$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1} 
$IPaddress=$ip.ipaddress[0] 
# From : https://blogs.technet.microsoft.com/heyscriptingguy/2014/04/10/powertip-use-powershell-to-get-ip-addresses/


if ($address -eq "REMOVED") { #If I'm in "REMOVED", use this IP for the photon
	$photonIP="REMOVED"
} else { #otherwise, assume I'm in "REMOVED", and use the "REMOVED" IP for the photon
	$photonIP="REMOVED"
}

$port=8888
#$portWeather=8889 # This functionallity is not yet implemented


# Use my read-weather function to get the weather
$data=Read-Weather

if ($data.Name) {# If the name function exists, the the function called correctly
	$tempF=$data.main.temp
	$udp=[char][int]"$tempF" #Convert it to the right datatype
	Send-Datagram $udp $photonIP $port
	exit(0)
} else {
	echo "Unable to read temperature"
	exit(1)
}
