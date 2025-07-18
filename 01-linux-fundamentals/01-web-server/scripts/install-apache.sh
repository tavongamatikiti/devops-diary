#!/bin/bash

# Apache Installation Script for Ubuntu
echo "Installing Apache2..."

# Update system
sudo apt update

# Install Apache
sudo apt install apache2 -y

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Check status
sudo systemctl status apache2

echo "Apache installation completed!"
echo "Access your website at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
