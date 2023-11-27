#!/bin/bash

create_certificate_for_service() {
  local service_name=$1
  openssl genrsa -out "${service_name}_key.pem" 4096
  openssl req -new -sha256 -subj "/CN=${service_name}-template.com" -key "${service_name}_key.pem" -passin env:SERVICE_PASS -out "${service_name}_ca.csr"
  openssl x509 -req -sha256 -days "$SSL_VALIDITY_DAYS" -in "${service_name}_ca.csr" -CA root-ca.pem -CAkey root-ca-key.pem -passin env:SERVICE_PASS -out "${service_name}_cert.pem" -extfile config/extfile.cnf -CAcreateserial
  cat "${service_name}_cert.pem" root-ca.pem > "${service_name}_chain.pem"
  mkdir -p "../docker/${service_name}/ssl"
  mv "${service_name}_chain.pem" "${service_name}_key.pem" "../docker/${service_name}/ssl"
  rm "${service_name}_cert.pem" "${service_name}_ca.csr"
}

if [ -z "$SERVICE_PASS" ]; then
    echo "The SERVICE_PASS environment variable is not set."
    exit 1
fi

if [ -f .env ]; then
  export $(cat .env | sed "s/#.*//g" | xargs)
fi

SSL_VALIDITY_DAYS="${SSL_VALIDITY_DAYS:-100}"

IFS=',' read -r -a services <<< "${SSL_SERVICES:-}"

if [ ! -f root-ca-key.pem ] || [ ! -f root-ca.pem ]; then
  openssl genrsa -aes256 -passout env:SERVICE_PASS -out root-ca-key.pem 4096
  openssl req --new -x509 -sha256 -subj "/CN=root-template.com" -days "$SSL_VALIDITY_DAYS" -key root-ca-key.pem -passin env:SERVICE_PASS -out root-ca.pem
  cp "root-ca-key.pem" "root-ca.pem" powershell
fi

for service in "${services[@]}"; do
  create_certificate_for_service "$service"
done

