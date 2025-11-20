param(
    [Parameter(Mandatory=$false)]
    [string]$BasePath
)

Set-Location -Path $PSScriptRoot

$Cert = Import-Certificate -FilePath "${BasePath}root-ca.pem" -CertStoreLocation Cert:\LocalMachine\Root
$Cert.Thumbprint | Out-File -FilePath "${BasePath}thumbprint.txt"
