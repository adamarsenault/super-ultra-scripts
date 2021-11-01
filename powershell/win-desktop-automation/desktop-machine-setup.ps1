$appspath = $PSScriptRoot + '\' + 'desktop-machine-apps.txt'
$apps = Get-Content -Path $appspath

if (-not (choco config get cacheLocation))
{
    Write-Host "Chocolatey not detected, attempting to install now"
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
else
{
    Write-Host "Chocolatey dectected, attempting to install applications from config file."
}

if ((choco config get cacheLocation))
{
    try {  
        foreach ($app in $apps)
        {
            Write-Host "Installing $app"
            & choco install $app /y  | Write-Host
        }
    } catch {
        Write-Error -Message "$app failed to install."
    }
}