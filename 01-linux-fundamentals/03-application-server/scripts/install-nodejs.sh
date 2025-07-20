#!/bin/bash

# Node.js and PM2 Installation Script
echo "Installing Node.js and PM2..."

# Install Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs -y

# Install PM2 globally
sudo npm install -g pm2

# Verify installations
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "PM2 version: $(pm2 --version)"

echo "✅ Node.js and PM2 installation completed!"
