#!/bin/bash

# Application Setup Script
APP_DIR="/opt/nexus-api"

echo "Setting up Node.js application..."

# Load nvm if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Create application directory
sudo mkdir -p $APP_DIR
sudo chown ubuntu:ubuntu $APP_DIR
cd $APP_DIR

# Initialize Node.js project
npm init -y

# Install dependencies using Yarn
yarn add express pg cors helmet morgan bcryptjs jsonwebtoken dotenv prom-client
yarn add --dev nodemon

echo "✅ Application setup completed!"
echo "Next: Create app.js and ecosystem.config.js files"
