param(
    [Parameter(Mandatory=$false)]
    [string]$FilePath = "thumbprint.txt"
)

# Function to prompt user action when the thumbprint file does not exist
function PromptUserAction {
    Get-ChildItem -Path Cert:\LocalMachine\Root | Format-Table Thumbprint, Subject -AutoSize
    Write-Host "The thumbprint file does not exist. Please prepare the file with the thumbprint."
    return
}

# Check if the thumbprint file exists
if (Test-Path $FilePath) {
    # Read the thumbprint from the file
    $Thumbprint = Get-Content $FilePath

    # Validate that thumbprint is not empty
    if([string]::IsNullOrWhiteSpace($Thumbprint)) {
        Write-Warning "Thumbprint in file $FilePath is empty. Please ensure the thumbprint is correct."
        return
    }

    # Attempt to remove the certificate with the given thumbprint
    try {
        Get-ChildItem -Path Cert:\LocalMachine\Root |
                Where-Object { $_.Thumbprint -eq $Thumbprint } |
                Remove-Item -WhatIf # Remove -WhatIf to perform the actual deletion
        Write-Host "Certificate with thumbprint $Thumbprint removed successfully."
    }
    catch {
        Write-Error "An error occurred: $_"
    }
} else {
    # File does not exist, prompt user for action
    PromptUserAction
}
