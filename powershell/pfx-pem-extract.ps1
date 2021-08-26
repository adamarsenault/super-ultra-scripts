## Powershell script used to generate .pem files from a .pfx file in preparation for upload to AWS ACM ##

Write-Host "Open the .pfx file received from Certificate Authority"
# Open file dialog to input certificate file
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'Certificates (*.pfx)|*.pfx'
}
$result = $FileBrowser.ShowDialog()

if ($result -eq "OK") {
    # Get path for certificate to import
    $Certificate = $FileBrowser.FileName
}
else {
throw "Script failed because a certificate file was not found. Exiting script."
}

# Get TLD from the certificate file path
$TLD = (Get-Item $Certificate).BaseName
# Get folder path that certificate file exists in
$CertPath = Split-Path -Path $Certificate
# Create variable that includes the path and TLD without file extension
$CertOut = $CertPath + '\' + $TLD
# Open dialog box to enter password
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$CertPassword = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the password for this certificate found in Password Manager","CertPassword")

# Extract public, private, and certificate chains from the pfx file 
openssl pkcs12 -in $Certificate -nocerts -nodes -passin pass:$CertPassword -out $CertOut'.priv.pem'
openssl pkcs12 -in $Certificate -nokeys -clcerts -nodes -passin pass:$CertPassword -out $CertOut'.pem'
openssl pkcs12 -in $Certificate -cacerts -nokeys -chain -passin pass:$CertPassword -out $CertOut'.chain.pem'