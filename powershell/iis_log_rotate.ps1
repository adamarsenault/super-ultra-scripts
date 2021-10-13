# PowerShell script for IIS log rotation and retention
# Original source: https://devblogs.microsoft.com/scripting/use-powershell-to-maintain-iis-logs/
# Modified by Adam A - 10/13/2021
# 7-Zip downloaded from: https://www.7-zip.org/



#Setting Global variables

# Location of IIS logs - note double '\' - \\ is used in the -replace command below
$Global:logDir = 'C:\\inetpub\\logs\\LogFiles\\'
# Archive directory location - trailing slash matters
$Global:archDir = "\\$env:USERDOMAIN\path\to\archive\$env:COMPUTERNAME\" 
# Output log
$Global:logFile = 'c:\temp\iis_rotate_log.txt'
# Friendly timestamp
$Global:logTime = Get-Date -Format 'MM-dd-yyyy_hh-mm-ss'


if (-not (Test-Path -Path "$logFile"))  # Check if $logfile exists
{
    if (-not (Test-Path (Split-Path -Path $logFile))) # If logfile does not exists, check if directory exists
    {
        New-Item (Split-Path -Path $logFile) -ItemType Directory # Create directory if it does not exist
    }
    New-Item -Path $LogFile -ItemType File # Create logfile if it does not exist
}


#Fresh log file on each execution
Clear-Content $LogFile


#Define Functions

Function Compress-Logs
{

<#### 7-Zip variable source: http://mats.gardstad.se/matscodemix/2009/02/05/calling-7-zip-from-powershell/
# Alias for 7-zip ##>
    # Update path to point to the location of 7-zip
    if (-not (Test-Path -Path "$env:ProgramFiles\7-Zip\7z.exe"))  
    {

        throw "$env:ProgramFiles\7-Zip\7z.exe needed"

    }
    Set-Alias -Name sz -Value "$env:ProgramFiles\7-Zip\7z.exe"
    $days = ‘-6’ # This will result in 7 days of non-zipped log files
    $logs = Get-ChildItem -Recurse -Path $logdir -Attributes !Directory -Filter *.log  | Where-Object -FilterScript {
        $_.LastWriteTime -lt (Get-Date).AddDays($days)
    }

    foreach ($log in $logs)
    {
        $name = $log.name # Gets the filename
        $directory = $log.DirectoryName # Get the directory name
        $LastWriteTime = $log.LastWriteTime # Gets lastwritetime of the file
        $zipfile = $name.Replace('.log', '.7z') # Creates the zipped filename
        sz a -t7z "$directory\$zipfile" "$directory\$name" # Runs 7-zip with the provided parameters – name and location of the zip file and the file to zip
        if ($LastExitCode -eq 0) # Verifies the zip process was successful
        {
            Get-ChildItem $directory -Filter $zipfile | ForEach-Object { $_.LastWriteTime = $LastWriteTime } # Sets the LastWriteTime of the zip file to match the original log file
            Remove-Item -Path $directory\$name # Deletes the original log file
            $logtime + ': Created archive ' + $directory + '\' + $zipfile + '. Deleted original logfile: ' + $name | Out-File $logfile -Encoding UTF8 -Append # Writes logfile entry
        }
    }
}

Function Move-Logs {

    $archiveDays = '-13' # This will provide 7 days of zipped log files in the original directory - all others will be archived
    $logFolders = Get-ChildItem -Path $logdir -Attributes Directory # Gets the folders in the log directory
    $zipLogs = Get-ChildItem -Recurse -Path $logdir -Attributes !Directory -Filter *.7z  | Where-Object -FilterScript {
        $_.LastWriteTime -lt (Get-Date).AddDays($archiveDays)
    } # Gets the zipped logs
    foreach ($logFolder in $logFolders)
    {
        $folder = $logFolder.name # Gets the directory the logfile is in
        $folder = $folder -replace $logdir, '' # Removes the original log directory keeping on the child portion of the name .ie c:\wwwlogs\w3svc becomes w3svc – needed for the folder creation and file move portions of this function
        $targetDir = $archdir + $folder
        if (!(Test-Path -Path $targetDir -PathType Container))  # Checks if the folder exists in the archive location
        {
            New-Item -ItemType directory -Path $targetDir # Creates folder if it doesn’t exist
        }
    }

    foreach ($ziplog in $zipLogs)
    {
        $origZipDir = $ziplog.DirectoryName # Gets the current folder name
        $fileName = $ziplog.Name # Gets the current zipped log name
        $source = $origZipDir + '\' + $fileName # Builds the source data
        $destDir = $origZipDir -replace $logdir, '' # Removes the parent log folder
        $destination = $archdir + $destDir + '\' + $fileName # Builds the destination data
        Move-Item $source -Destination $destination # Moves the file from the current location to the archive location
        $logtime + ': Moved archive ' + $source + ' to ' + $destination | Out-File $logfile -Encoding UTF8 -Append # Creates logfile entry
    }
}

Function Remove-Logs {
    # Retains X months of logs - adjust to meet desired retention plan  
    $delMonths = '-12' 
    # Gets the list of logs older than specified for deletion
    $delLogs = Get-ChildItem -Recurse -Path $archdir -Attributes !Directory -Filter *.7z  | Where-Object -FilterScript {
        $_.LastWriteTime -lt (Get-Date).AddMonths($delMonths)
    } 

    Foreach ($delLog in $delLogs) {
        $filename = $delLog.Name # Gets the filename
        $delDir = $delLog.DirectoryName # Gets the directory
        $delFile = $delDir + '\' + $filename # Builds the delete data
        Remove-Item $delFile # Deletes the file
        $logtime + ': Deleted archive ' + $delfile | Out-File $logfile -Encoding UTF8 -Append
    } # Creates the logfile entry
}

# Main script execution

Compress-Logs

Move-Logs

Remove-Logs