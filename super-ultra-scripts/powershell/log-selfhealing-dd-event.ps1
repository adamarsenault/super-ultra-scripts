#Formatted timestamps
$Timestamp = Get-Date -Format "MM/dd/yy HH:mm:ss"

#Set TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Error action to trigger catch
$ErrorActionPreference = "Stop"

#Set DD Variables for Event Posting
$url = 'https://api.datadoghq.com/api/v1/events'
$headers = @{
    'Content-Type' = 'application/json'
	'DD-API-KEY' = '#######################'
}
$DDEvent = @{
    text = "Text to include in the alert, including @DATADOGGROUP to page or notify"
    title = "Title of your Event or Alert"
    alert_type = "error"
    priority = "normal"
    host = hostname
}
$body = ConvertTo-Json -InputObject $DDEvent

#Log trim variables
$maxlines = 100000
$logfile = 'D:\path\to\log'

#Tailing log 35 lines (line count of the error). Quiet parameter to return boolean.
if(Get-Content $logfile -Tail 35 | Select-String -Pattern 'ERROR Message to Tail' -Quiet)
{
    try
    {
        #If errors found, attempt to restart service. Send alert if restart fails.
        Write-Output "[$Timestamp] Errors found in log. Restarting the service." | Out-File $logfile -encoding ASCII -Append
        Restart-Service Service
    }
    catch
    { 
        Write-Output "[$Timestamp] Service restart failed. Sending event to Datadog to notify the team." | Out-File $logfile -encoding ASCII -Append
        Invoke-RestMethod -Method 'Post' -Uri $url -Headers $headers -Body $body
    }
 }
else
{
    Write-Output "[$Timestamp] No errors found in log. Checking again in 300 seconds." | Out-File $logfile -encoding ASCII -Append
}

#Trimming logfile to under 100k lines
(Get-Content $logfile -tail $maxlines -readcount 0) | Set-Content $logfile

exit