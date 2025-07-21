#!/bin/bash

# Alternative: Deploy Application via HTTP Server
SOURCE_SERVER="172.31.31.161"
TARGET_SERVERS=("172.31.45.183" "172.31.47.48")
SERVER_NAMES=("nexus-beta" "nexus-gamma")

echo "Deploying application to additional servers via HTTP..."

# Create application package
cd /opt/nexus-api
tar czf nexus-api-deployment.tar.gz --exclude=node_modules --exclude=logs/*.log .

# Start HTTP server for file transfer
echo "🌐 Starting HTTP server for file transfer..."
python3 -m http.server 8000 &
HTTP_PID=$!

sleep 2

# Deploy to each target server
for i in "${!TARGET_SERVERS[@]}"; do
    SERVER_IP="${TARGET_SERVERS[$i]}"
    SERVER_NAME="${SERVER_NAMES[$i]}"

    echo "Deploying to $SERVER_NAME ($SERVER_IP) via HTTP..."

    ssh ubuntu@$SERVER_IP << REMOTE_DEPLOY
        cd /opt/nexus-api
        curl -O http://$SOURCE_SERVER:8000/nexus-api-deployment.tar.gz
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
        rm nexus-api-deployment.tar.gz
REMOTE_DEPLOY

    echo "✅ HTTP deployment to $SERVER_NAME completed"
done

# Stop HTTP server and clean up
kill $HTTP_PID
rm nexus-api-deployment.tar.gz

echo "🎉 Application deployed to all servers via HTTP!"
