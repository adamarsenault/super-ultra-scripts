# super-ultra-scripts
## Misc Notes

###### Open SSL Installation
The [Git for Windows](https://gitforwindows.org/) installation includes OpenSSL; to call it within command prompt or PowerShell, we can add that location to the PATH environment variable. 

1. Adding the Git for Windows Bin directory to Windows PATH
 - `$env:Path += ";C:\Program Files\Git\usr\bin\"`
2. Close/Reopen CMD Prompt or PowerShell
3. Type openssl and press Enter; this should no longer produce an error message