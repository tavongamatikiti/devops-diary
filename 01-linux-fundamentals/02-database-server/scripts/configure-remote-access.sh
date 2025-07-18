#!/bin/bash

# Configure PostgreSQL for Remote Access
echo "Configuring PostgreSQL for remote access..."

# Variables
PG_VERSION="16"
PG_CONFIG_DIR="/etc/postgresql/${PG_VERSION}/main"
# Replace the default IP with your application server's private IP
ALLOWED_IP="${1:-172.31.0.0/32}"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <allowed_ip_with_cidr>"
    echo "Example: $0 172.31.5.100/32"
    echo "Using default: $ALLOWED_IP (replace with your server's IP)"
fi

# Backup original files
sudo cp ${PG_CONFIG_DIR}/postgresql.conf ${PG_CONFIG_DIR}/postgresql.conf.backup
sudo cp ${PG_CONFIG_DIR}/pg_hba.conf ${PG_CONFIG_DIR}/pg_hba.conf.backup

# Configure postgresql.conf
echo "Updating postgresql.conf..."
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" ${PG_CONFIG_DIR}/postgresql.conf

# Configure pg_hba.conf
echo "Updating pg_hba.conf..."
echo "host    nexus_db    nexus_admin    ${ALLOWED_IP}    md5" | sudo tee -a ${PG_CONFIG_DIR}/pg_hba.conf

# Restart PostgreSQL
echo "Restarting PostgreSQL..."
sudo systemctl restart postgresql@${PG_VERSION}-main

# Verify configuration
echo "Verifying configuration..."
sudo netstat -tlnp | grep 5432

echo "Remote access configuration completed!"
echo "PostgreSQL should now accept connections from: $ALLOWED_IP"
