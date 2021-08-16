#Set TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url = 'https://api.datadoghq.com/api/v1/events'
$headers = @{
    'Content-Type' = 'application/json'
	'DD-API-KEY' = '##########################'
}
$Event = @{
    text = "Text to include in the alert, including @DATADOGGROUP to page or notify"
    title = "Title of your Event or Alert"
    alert_type = "error"
    priority = "normal"
    host = hostname
}

$body = ConvertTo-Json -InputObject $Event

Invoke-RestMethod -Method 'Post' -Uri $url -Headers $headers -Body $body