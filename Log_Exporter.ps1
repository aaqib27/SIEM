# Get API key from here httpsipgeolocation.io
$API_KEY      = d3c79f76871242f799938dead532bd77
$LOGFILE_NAME = failed_rdp.log
$LOGFILE_PATH = CProgramData$($LOGFILE_NAME)

# This filter will be used to filter failed RDP events from Windows Event Viewer
$XMLFilter = @'
QueryList 
   Query Id=0 Path=Security
         Select Path=Security
              [System[(EventID='4625')]]
          Select
    Query
QueryList 
'@

#
    This function creates a bunch of sample log files that will be used to train the
    Extract feature in Log Analytics workspace. If you don't have enough log files to
    train it, it will fail to extract certain fields for some reason -_-.
    We can avoid including these fake records on our map by filtering out all logs with
    a destination host of samplehost
#
Function write-Sample-Log() {
    latitude47.91542,longitude-120.60306,destinationhostsamplehost,usernamefakeuser,sourcehost24.16.97.222,stateWashington,countryUnited States,labelUnited States - 24.16.97.222,timestamp2021-10-26 032829  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude-22.90906,longitude-47.06455,destinationhostsamplehost,usernamelnwbaq,sourcehost20.195.228.49,stateSao Paulo,countryBrazil,labelBrazil - 20.195.228.49,timestamp2021-10-26 054620  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude52.37022,longitude4.89517,destinationhostsamplehost,usernameCSNYDER,sourcehost89.248.165.74,stateNorth Holland,countryNetherlands,labelNetherlands - 89.248.165.74,timestamp2021-10-26 061256  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude40.71455,longitude-74.00714,destinationhostsamplehost,usernameADMINISTRATOR,sourcehost72.45.247.218,stateNew York,countryUnited States,labelUnited States - 72.45.247.218,timestamp2021-10-26 104407  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude33.99762,longitude-6.84737,destinationhostsamplehost,usernameAZUREUSER,sourcehost102.50.242.216,stateRabat-Salé-Kénitra,countryMorocco,labelMorocco - 102.50.242.216,timestamp2021-10-26 110313  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude-5.32558,longitude100.28595,destinationhostsamplehost,usernameTest,sourcehost42.1.62.34,statePenang,countryMalaysia,labelMalaysia - 42.1.62.34,timestamp2021-10-26 110445  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude41.05722,longitude28.84926,destinationhostsamplehost,usernameAZUREUSER,sourcehost176.235.196.111,stateIstanbul,countryTurkey,labelTurkey - 176.235.196.111,timestamp2021-10-26 115047  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude55.87925,longitude37.54691,destinationhostsamplehost,usernameTest,sourcehost87.251.67.98,statenull,countryRussia,labelRussia - 87.251.67.98,timestamp2021-10-26 121345  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude52.37018,longitude4.87324,destinationhostsamplehost,usernameAZUREUSER,sourcehost20.86.161.127,stateNorth Holland,countryNetherlands,labelNetherlands - 20.86.161.127,timestamp2021-10-26 123346  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude17.49163,longitude-88.18704,destinationhostsamplehost,usernameTest,sourcehost45.227.254.8,statenull,countryBelize,labelBelize - 45.227.254.8,timestamp2021-10-26 131325  Out-File $LOGFILE_PATH -Append -Encoding utf8
    latitude-55.88802,longitude37.65136,destinationhostsamplehost,usernameTest,sourcehost94.232.47.130,stateCentral Federal District,countryRussia,labelRussia - 94.232.47.130,timestamp2021-10-26 142533  Out-File $LOGFILE_PATH -Append -Encoding utf8
}

# This block of code will create the log file if it doesn't already exist
if ((Test-Path $LOGFILE_PATH) -eq $false) {
    New-Item -ItemType File -Path $LOGFILE_PATH
    write-Sample-Log
}

# Infinite Loop that keeps checking the Event Viewer logs.
while ($true)
{
    
    Start-Sleep -Seconds 1
    # This retrieves events from Windows EVent Viewer based on the filter
    $events = Get-WinEvent -FilterXml $XMLFilter -ErrorAction SilentlyContinue
    if ($Error) {
        #Write-Host No Failed Logons found. Re-run script when a login has failed.
    }

    # Step through each event collected, get geolocation
    #    for the IP Address, and add new events to the custom log
    foreach ($event in $events) {


        # $event.properties[19] is the source IP address of the failed logon
        # This if-statement will proceed if the IP address exists (= 5 is arbitrary, just saying if it's not empty)
        if ($event.properties[19].Value.Length -ge 5) {

            # Pick out fields from the event. These will be inserted into our new custom log
            $timestamp = $event.TimeCreated
            $year = $event.TimeCreated.Year

            $month = $event.TimeCreated.Month
            if ($($event.TimeCreated.Month).Length -eq 1) {
                $month = 0$($event.TimeCreated.Month)
            }

            $day = $event.TimeCreated.Day
            if ($($event.TimeCreated.Day).Length -eq 1) {
                $day = 0$($event.TimeCreated.Day)
            }
            
            $hour = $event.TimeCreated.Hour
            if ($($event.TimeCreated.Hour).Length -eq 1) {
                $hour = 0$($event.TimeCreated.Hour)
            }

            $minute = $event.TimeCreated.Minute
            if ($($event.TimeCreated.Minute).Length -eq 1) {
                $minute = 0$($event.TimeCreated.Minute)
            }


            $second = $event.TimeCreated.Second
            if ($($event.TimeCreated.Second).Length -eq 1) {
                $second = 0$($event.TimeCreated.Second)
            }

            $timestamp = $($year)-$($month)-$($day) $($hour)$($minute)$($second)
            $eventId = $event.Id
            $destinationHost = $event.MachineName# Workstation Name (Destination)
            $username = $event.properties[5].Value # Account Name (Attempted Logon)
            $sourceHost = $event.properties[11].Value # Workstation Name (Source)
            $sourceIp = $event.properties[19].Value # IP Address
        

            # Get the current contents of the Log file!
            $log_contents = Get-Content -Path $LOGFILE_PATH

            # Do not write to the log file if the log already exists.
            if (-Not ($log_contents -match $($timestamp)) -or ($log_contents.Length -eq 0)) {
            
                # Announce the gathering of geolocation data and pause for a second as to not rate-limit the API
                #Write-Host Getting Latitude and Longitude from IP Address and writing to log -ForegroundColor Yellow -BackgroundColor Black
                Start-Sleep -Seconds 1

                # Make web request to the geolocation API
                # For more info httpsipgeolocation.iodocumentationip-geolocation-api.html
                $API_ENDPOINT = httpsapi.ipgeolocation.ioipgeoapiKey=$($API_KEY)&ip=$($sourceIp)
                $response = Invoke-WebRequest -UseBasicParsing -Uri $API_ENDPOINT

                # Pull Data from the API response, and store them in variables
                $responseData = $response.Content  ConvertFrom-Json
                $latitude = $responseData.latitude
                $longitude = $responseData.longitude
                $state_prov = $responseData.state_prov
                if ($state_prov -eq ) { $state_prov = null }
                $country = $responseData.country_name
                if ($country -eq ) {$country -eq null}

                # Write all gathered data to the custom log file. It will look something like this
                #
                latitude$($latitude),longitude$($longitude),destinationhost$($destinationHost),username$($username),sourcehost$($sourceIp),state$($state_prov), country$($country),label$($country) - $($sourceIp),timestamp$($timestamp)  Out-File $LOGFILE_PATH -Append -Encoding utf8

                Write-Host -BackgroundColor Black -ForegroundColor Magenta latitude$($latitude),longitude$($longitude),destinationhost$($destinationHost),username$($username),sourcehost$($sourceIp),state$($state_prov),label$($country) - $($sourceIp),timestamp$($timestamp)
            }
            else {
                # Entry already exists in custom log file. Do nothing, optionally, remove the # from the line below for output
                # Write-Host Event already exists in the custom log. Skipping. -ForegroundColor Gray -BackgroundColor Black
            }
        }
    }
}