# Development Template for API & Web Services

This repository serves as a template for developing API and web services, utilizing Symfony framework for backend and Next.js for frontend. The architecture is designed to facilitate Docker-based development, optimized for Windows with WSL, and is easily adaptable for Linux & Docker environments.

## Prerequisites

- Docker installed on your system
- Docker Compose for orchestrating multi-container Docker applications

## Getting Started

### Environment Setup

Before running the application, environment variables must be set. Execute the following command in the root of the repository to copy `.env.example` files to `.env`:

```bash
find . -type f -name ".env.example" -exec sh -c 'cp "$0" "${0%.example}"' {} \;
```
> **Important:** `.env` files contain sensitive information and should not be committed to the repository.

### Running the Application
With `.env` files prepared, start the application using Docker Compose:

```bash
docker-compose up -d
```
This will build and run the following services:

### SSL Certificates
The `ssl/` directory contains scripts to generate SSL certificates for securing your local services. Follow the instructions in `ssl/readme.md` to generate and manage your SSL certificates.

### Reverse Proxy and SSL
To use the reverse proxy, you need to add domain mapping to your hosts file (on both Windows and Linux). By default, the SSL certificates are prepared for ***.template.com** subdomains.

#### For Windows:
Add the following line to the hosts file located at `C:\Windows\System32\drivers\etc\hosts`
```bash
127.0.0.1       nginx.template.com
127.0.0.1       next.template.com
127.0.0.1       mailhog.template.com
```
#### For Linux:
Add the following line to the `/etc/hosts` file
```bash
127.0.0.1       nginx.template.com
127.0.0.1       next.template.com
127.0.0.1       mailhog.template.com
```
> **Note:** The default SSL certificates can be reconfigured by modifying the `ssl/config/extfile.cnf` file according to your domain needs.

## Running Tests

Before submitting a merge request, please ensure that the project passes the GitHub CI/CD pipeline. The following tests
are performed:

- **PHP Code Sniffer**: Checks the code against coding standards to ensure consistency.

   ``` bash
   docker-compose exec -t php sh -c "XDEBUG_MODE=off php vendor/bin/phpcs"
   ```
- **PHPStan**: Performs static analysis to identify potential errors and improve code quality.

   ``` bash
   docker-compose exec -t php sh -c "XDEBUG_MODE=off php vendor/bin/phpstan analyse"
   ```
- **PHPUnit Tests**: Runs the unit tests to ensure the functionality of the application.

   ``` bash
   docker-compose exec -t php sh -c "XDEBUG_MODE=off php vendor/bin/phpunit"
   ```

Make sure all tests pass without any errors before submitting your merge request.