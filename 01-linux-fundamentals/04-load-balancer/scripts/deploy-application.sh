#!/bin/bash

# Deploy Application to Additional Servers Script
SOURCE_SERVER="172.31.31.161"
TARGET_SERVERS=("172.31.45.183" "172.31.47.48")
SERVER_NAMES=("nexus-beta" "nexus-gamma")

echo "Deploying application to additional servers..."

# Check if SSH key exists
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "❌ SSH key not found. Please set up SSH key first:"
    echo "ssh-keygen -t rsa -b 2048"
    echo "Then copy your key to target servers"
    exit 1
fi

# Method 1: Using SCP with SSH Key (Recommended)
echo "📦 Creating application package..."
cd /opt/nexus-api
tar czf nexus-api-deployment.tar.gz --exclude=node_modules --exclude=logs/*.log .

echo "🔐 Using SCP deployment method..."
for i in "${!TARGET_SERVERS[@]}"; do
    SERVER_IP="${TARGET_SERVERS[$i]}"
    SERVER_NAME="${SERVER_NAMES[$i]}"

    echo "Deploying to $SERVER_NAME ($SERVER_IP) via SCP..."

    # Copy deployment package via SCP
    scp nexus-api-deployment.tar.gz ubuntu@$SERVER_IP:/tmp/

    # Deploy on remote server
    ssh ubuntu@$SERVER_IP << REMOTE_DEPLOY
        cd /opt/nexus-api
        cp /tmp/nexus-api-deployment.tar.gz .
        tar xzf nexus-api-deployment.tar.gz

        # Install dependencies
        export NVM_DIR="\$HOME/.nvm"
        [ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
        yarn install

        # Set server-specific environment
        echo "SERVER_NAME=$SERVER_NAME" >> .env

        # Start application
        pm2 start ecosystem.config.js
        pm2 save
        pm2 startup

        # Clean up
        rm /tmp/nexus-api-deployment.tar.gz nexus-api-deployment.tar.gz
REMOTE_DEPLOY

    echo "✅ SCP deployment to $SERVER_NAME completed"
done

# Clean up local deployment package
rm nexus-api-deployment.tar.gz

echo "🎉 Application deployed to all servers via SCP!"
