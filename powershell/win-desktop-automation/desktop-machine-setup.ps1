## Desktop Automation Script for Personal Use
## Inspiration from: https://octopus.com/blog/automate-developer-machine-setup-with-chocolatey
## Enter applications to install (one per line) in file desktop-machine-apps.txt
## File and script must reside in the same directory
## Script must be executed in a elevated PowerShell session

# Set variables for config file + path to config file
$appspath = $PSScriptRoot + '\' + 'desktop-machine-apps.txt'
# Create array from the desktop-machine-apps.txt file
$apps = Get-Content -Path $appspath

# Verify if chocolatey is installed, if not try to install
try {
    choco config get cacheLocation
} catch {
    Write-Host "Chocolatey not detected, attempting to install now"
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# If chocolatey config returns a version, attempt to install applications from desktop-machine-apps.txt
if ((choco config get cacheLocation))
{
    try {  
        Write-Host "Chocolatey dectected, attempting to install applications from config file."
        # Iterate the choco install command for each application in desktop-machine-apps.txt
        foreach ($app in $apps)
            {
                Write-Host "Installing $app"
                & choco install $app /y  | Write-Host
            }
    } catch {
        # Reminder on where to configure the desktop-machine-apps.txt file and where to find chocolatey-logs.
        "An error has occurred when installing applications. Do you have applications defined in ./desktop-machine-apps.txt? Review choco logs C:\ProgramData\chocolatey\logs\chocolatey.log."
    }
}
else
{ 
    # Throw error if choco config does not run after attempts to install
    Write-Error -Message "Machine setup did not run correctly." -RecommendedAction "Run script as elevated administrator and/or manually install chocolatey and try again."
}