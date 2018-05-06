## Plot forecast
## Other stuff
$url="http://api.openweathermap.org/data/2.5/forecast?id= " + $CITYID + "&appid=" + $apikey+"&units=imperial"
$webread=invoke-webrequest $url
$data=convertfrom-json $webread.content



# #Get max forecasted weather
# $data.list.main.temp_max | measure -max

# #Get min forecasted weather
# $data.list.main.temp_min | measure -min


# Get temperature forecast
# $data.list.main.temp


# Get weather forecast
# $data.list.main.weather

# Get times
# $data.list.dt

$localtime = foreach ($element in $data.list.dt) {convert-unixtime $element}

$temp=$data.list.main.temp
$tempmax=$data.list.main.temp_max
$tempmin=$data.list.main.temp_min
$humidity=$data.list.main.humidity


## Plot out temperature data
#https://blogs.technet.microsoft.com/richard_macdonald/2009/04/28/charting-with-powershell/
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.Datavisualization")


$chart = New-Object System.Windows.Forms.Datavisualization.charting.chart
$chart.width = 600
$chart.Height = 400
$chart.Top = 40
$chart.Left = 30

$chartArea = New-Object System.windows.Forms.Datavisualization.charting.chartArea
$chart.chartAreas.Add($chartArea)

[Void]$chart.Titles.Add("Peak Report")
$chartArea.AxisX.Title = "Date"
$chartArea.AxisY.Title = "degF/%RH"
$chart.Titles[0].Font = "Arial,13pt"
$chartArea.AxisX.TitleFont = "Arial,13pt"
$chartArea.AxisY.TitleFont = "Arial,13pt"
$chartArea.AxisY.Interval = 50
$chartArea.AxisX.Interval = 1

#Legend
$legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
$legend.name = "Legend"
$chart.Legends.Add($legend)

#$Chart.BackColor = [System.Drawing.Color]::White

# data series  
[void]$chart.Series.Add("Temperature")  
$chart.Series["Temperature"].ChartType = "Line"  
$chart.Series["Temperature"].BorderWidth = 3  
$chart.Series["Temperature"].IsVisibleInLegend = $true  
$chart.Series["Temperature"].chartarea = "ChartArea1"  
$chart.Series["Temperature"].Legend = "Legend"  
$chart.Series["Temperature"].color = "#62B5CC"  
$chart.Series["Temperature"].Points.DataBindXY($localtime, $temp)


[void]$chart.Series.Add("Humidity")  
$chart.Series["Humidity"].ChartType = "Line"  
$chart.Series["Humidity"].BorderWidth = 3  
$chart.Series["Humidity"].IsVisibleInLegend = $true  
$chart.Series["Humidity"].chartarea = "ChartArea1"  
$chart.Series["Humidity"].Legend = "Legend"  
$chart.Series["Humidity"].color = "#f931d5"  
$chart.Series["Humidity"].Points.DataBindXY($localtime, $humidity)

# display the chart on a form 
$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
$Form = New-Object Windows.Forms.Form 
$Form.Text = "PowerShell Chart" 
$Form.Width = 650 
$Form.Height = 450 
$Form.controls.add($Chart) 
$Form.Add_Shown({$Form.Activate()}) 
$Form.ShowDialog()


