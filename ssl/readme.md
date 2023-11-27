# SSL Certificate Generation for Local Services

This folder contains scripts for generating SSL certificates for local development services. It uses OpenSSL for certificate generation and includes PowerShell scripts to manage root certificates on your system.

## Prerequisites

- OpenSSL installed for certificate generation.
- PowerShell installed to run the certificate management scripts (Windows).

## Directory Structure

The relevant files and directories for SSL certificate generation are as follows:

ssl\
├── config\
│ └── extfile.cnf\
├── powershell\
│ ├── ImportCertificate.ps1\
│ └── RemoveCertificate.ps1\
│── ssl.sh\
└── .gitignore

> **Note**: `*.pem` and `thumbprint.txt` files are ignored via `.gitignore` to prevent sensitive information from being committed to the repository.

### PowerShell Scripts and the Thumbprint.txt File

The `powershell` folder contains scripts for importing and removing the root certificate in the system's certificate store. The `ImportCertificate.ps1` script imports the `root-ca.pem` certificate and saves its thumbprint to a file named `thumbprint.txt`. This thumbprint is a cryptographic hash that uniquely identifies the certificate and is required for certificate management tasks.

When running the `RemoveCertificate.ps1` script, it looks for the `thumbprint.txt` file to retrieve the thumbprint and then locate and remove the corresponding certificate from the system. If the file does not exist or the thumbprint is not found, the script will prompt the user to provide the thumbprint manually.

## Configuration
Ensure the `config/extfile.cnf` file is in place as it is used by the script to configure the certificate extensions.

## Usage

### Generating SSL Certificates

To generate SSL certificates, set the `SERVICE_PASS` environment variable and run the `ssl.sh` script located in the `ssl` directory:

```bash
cd ssl
SERVICE_PASS="<password>" ./ssl.sh
```
The script utilizes the following environment variables:

* **SERVICE_PASS**: The password for accessing the service's private key.
* **SSL_SERVICES**: A comma-separated list of service names for which to generate certificates.
* **SSL_VALIDITY_DAYS**: The number of days for the SSL certificates' validity (default is 100 if not set).

### Winodows
#### Managing Trusted Root Certificates with PowerShell
In the `powershell` directory, two scripts are provided to import and remove root certificates:

* **ImportCertificate.ps1** - To import the root certificate to the system.
* **RemoveCertificate.ps1** - To remove the root certificate from the system.
These should be run from an Administrator PowerShell console with the following commands:

To import the root certificate:

```powershell
pwsh.exe -ExecutionPolicy Bypass -File .\powershell\ImportCertificate.ps1
```
To remove the root certificate:

```powershell
pwsh.exe -ExecutionPolicy Bypass -File .\powershell\RemoveCertificate.ps1
```
> **Note:** Both PowerShell scripts require _administrative privileges_ to modify the system's certificate store. To run these scripts, open `PowerShell` as an Administrator by right-clicking on the PowerShell icon and selecting **Run as Administrator**.

#### Manual Certificate Import on Windows

If you prefer to manually import the certificate without using `PowerShell`, you can do so using the `Microsoft Management Console (MMC)` or a web browser:

- **Using MMC:**
    1. Press `Win + R`, type `mmc`, and press `Enter` to open the Microsoft Management Console.
    2. Go to `File > Add/Remove Snap-in`, select `Certificates`, and click `Add`.
    3. Choose `Computer account`, then `Local computer`, and click `Finish`.
    4. Navigate to `Trusted Root Certification Authorities > Certificates`.
    5. Right-click on `Certificates`, choose `All Tasks > Import`, and follow the wizard to import your root certificate.

- **Using a Browser:**
  You can also import the certificate using a browser such as Chrome or Firefox by accessing the browser's settings for certificates and using the import function. This method, however, may not place the certificate in the system's certificate store and may only be recognized by the browser itself.

> **Note:** Administrative privileges may still be required to add a certificate to the system store or to certain browsers' stores.

### Linux
#### Importing Trusted Root Certificate on Debian-based Systems

To import the root certificate on Debian-based systems, follow these steps:

1. Copy your root certificate file (typically with a `.crt` extension) to the `/usr/local/share/ca-certificates/` directory. If your certificate is in PEM format with a `.pem` extension, you should rename it to `.crt`.

    ```bash
    sudo cp root-ca.pem /usr/local/share/ca-certificates/root-ca.crt
    ```

2. Update the list of trusted certificates using the `update-ca-certificates` utility:

    ```bash
    sudo update-ca-certificates
    ```

This command will automatically update the certificate store and make the root certificate trusted by the system. Your applications that rely on the system's trust store should now recognize certificates signed by this root certificate as trusted.

> **Note:** Administrative privileges are required to copy certificates to the `/usr/local/share/ca-certificates/` directory and to run `update-ca-certificates`. Ensure you have the necessary permissions before attempting these operations.
#### Removing the Trusted Root Certificate from Debian-based Systems

If you need to remove a root certificate that was previously added to the system's trust store on Debian-based systems, follow these steps:

1. Remove the certificate file from the `/usr/local/share/ca-certificates/` directory where it was placed:

    ```bash
    sudo rm /usr/local/share/ca-certificates/root-ca.crt
    ```

2. Update the list of trusted certificates to reflect the removal:

    ```bash
    sudo update-ca-certificates --fresh
    ```

The `--fresh` option with the `update-ca-certificates` command will regenerate the list of trusted certificates by only including those present in the `/usr/local/share/ca-certificates/` directory, effectively removing the trust for the deleted root certificate.

> **Note:** As with importing certificates, removing them also requires administrative privileges. Be cautious when removing certificates to avoid disrupting the operation of any system services or applications that may rely on that certificate.

### Important Notes
The SSL generation script and PowerShell scripts should be used with caution, particularly on production systems.
Always ensure to use strong, unique passwords for `SERVICE_PASS`.
