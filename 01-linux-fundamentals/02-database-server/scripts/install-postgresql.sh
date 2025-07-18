#!/bin/bash

# PostgreSQL Installation Script for Ubuntu
echo "Installing PostgreSQL..."

# Update system
sudo apt update

# Install PostgreSQL and additional tools
sudo apt install postgresql postgresql-contrib postgresql-client -y

# Start and enable PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Check installation
echo "PostgreSQL installation completed!"
echo "Service status:"
sudo systemctl status postgresql --no-pager

echo "PostgreSQL version:"
sudo -u postgres psql -c "SELECT version();"

echo ""
echo "Next steps:"
echo "1. Set postgres user password"
echo "2. Create database and users"
echo "3. Configure remote access"
