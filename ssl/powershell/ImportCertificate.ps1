param(
    [Parameter(Mandatory=$false)]
    [string]$BasePath
)

if (-not $BasePath) {
    $BasePath = $PSScriptRoot
}

$BasePath = $BasePath.TrimEnd('\') + '\'
$Cert = Import-Certificate -FilePath "${BasePath}root-ca.pem" -CertStoreLocation Cert:\LocalMachine\Root
$Cert.Thumbprint | Out-File -FilePath "${BasePath}thumbprint.txt"
