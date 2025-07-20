#!/bin/bash

# Node.js and PM2 Installation Script using NVM
echo "Installing Node.js via NVM and PM2..."

# Download and install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load nvm into current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Download and install Node.js version 22
nvm install 22

# Use Node.js version 22
nvm use 22

# Verify Node.js installation
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# Enable and install Yarn using corepack
corepack enable yarn

# Verify Yarn installation
echo "Yarn version: $(yarn -v)"

# Install PM2 globally
npm install -g pm2

# Verify PM2 installation
echo "PM2 version: $(pm2 --version)"

# Add nvm to bashrc for future sessions
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

echo "✅ Node.js (v22), Yarn, and PM2 installation completed!"
echo "Note: Restart your terminal or run 'source ~/.bashrc' to use nvm in new sessions"
