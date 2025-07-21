#!/bin/bash

# Setup Additional Application Servers Script
echo "Setting up additional application servers..."

SERVERS=("nexus-beta" "nexus-gamma")
SERVER_IPS=("172.31.45.183" "172.31.47.48")

for i in "${!SERVERS[@]}"; do
    SERVER_NAME="${SERVERS[$i]}"
    SERVER_IP="${SERVER_IPS[$i]}"

    echo "Setting up $SERVER_NAME ($SERVER_IP)..."

    # Install Node.js and dependencies
    ssh ubuntu@$SERVER_IP << 'REMOTE_SCRIPT'
        # Install nvm and Node.js
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install 22
        nvm use 22

        # Enable Yarn and install PM2
        corepack enable yarn
        npm install -g pm2

        # Create application directory
        sudo mkdir -p /opt/nexus-api
        sudo chown ubuntu:ubuntu /opt/nexus-api
REMOTE_SCRIPT

    echo "✅ $SERVER_NAME setup completed"
done

echo "🎉 All additional servers configured!"
