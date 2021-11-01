## Desktop Automation Script for Personal Use
## Inspiration from: https://octopus.com/blog/automate-developer-machine-setup-with-chocolatey

$appspath = $PSScriptRoot + '\' + 'desktop-machine-apps.txt'
$apps = Get-Content -Path $appspath

try {
    choco config get cacheLocation
} catch {
    Write-Host "Chocolatey not detected, attempting to install now"
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if ((choco config get cacheLocation))
{
    try {  
        Write-Host "Chocolatey dectected, attempting to install applications from config file."
        foreach ($app in $apps)
            {
                Write-Host "Installing $app"
                & choco install $app /y  | Write-Host
            }
    } catch {
        "An error has occurred when installing applications. Review choco logs C:\ProgramData\chocolatey\logs\chocolatey.log."
    }
}
else
{ 
    Write-Error -Message "Machine setup did not run correctly." -RecommendedAction "Run script as elevated administrator and/or manually install chocolatey and try again."
}