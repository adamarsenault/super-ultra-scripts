$ServiceName = 'SERVICENAME'
$svc = Get-Service -name $ServiceName
$Timestamp = Get-Date -Format "MM/dd/yy HH:mm:ss"
$Log = "X:\Path\To\Task\SERVICENAME.log"

while ($svc.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Stopped)
{
  Write-Output "[${Timestamp}] ${ServiceName} service is current stopped. Attempting to start." >> ${Log}
  Start-Service -Name ${ServiceName}
  Write-Output $svc.Status >> ${Log}
  Write-Output "[${Timestamp}] ${ServiceName} Service starting" >> ${Log}
  Start-Sleep -seconds 30
  $svc.Refresh()
  if($svc.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running)
  { 
    Write-Output "[${Timestamp}] ${ServiceName} Service is running" >> ${Log}
  }
}

exit