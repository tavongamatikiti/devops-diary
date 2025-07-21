#!/bin/bash

# SSH Key Setup Script for Server-to-Server Communication
TARGET_SERVERS=("172.31.45.183" "172.31.47.48")
SERVER_NAMES=("nexus-beta" "nexus-gamma")

echo "🔐 Setting up SSH keys for server-to-server communication..."

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
    echo "✅ SSH key pair generated"
else
    echo "✅ SSH key pair already exists"
fi

# Copy SSH key to target servers
for i in "${!TARGET_SERVERS[@]}"; do
    SERVER_IP="${TARGET_SERVERS[$i]}"
    SERVER_NAME="${SERVER_NAMES[$i]}"

    echo "Copying SSH key to $SERVER_NAME ($SERVER_IP)..."

    # Copy public key to authorized_keys (using your EC2 key)
    ssh -i /path/to/your-ec2-key.pem ubuntu@$SERVER_IP << 'REMOTE_SETUP'
        # Ensure .ssh directory exists
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh

        # Create authorized_keys if it doesn't exist
        touch ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys
REMOTE_SETUP

    # Copy the public key from source server
    cat ~/.ssh/id_rsa.pub | ssh -i /path/to/your-ec2-key.pem ubuntu@$SERVER_IP "cat >> ~/.ssh/authorized_keys"

    echo "✅ SSH key copied to $SERVER_NAME"
done

# Test SSH connectivity
echo "🧪 Testing SSH connectivity..."
for i in "${!TARGET_SERVERS[@]}"; do
    SERVER_IP="${TARGET_SERVERS[$i]}"
    SERVER_NAME="${SERVER_NAMES[$i]}"

    if ssh -o ConnectTimeout=5 ubuntu@$SERVER_IP "echo 'SSH connection successful'" 2>/dev/null; then
        echo "✅ SSH connection to $SERVER_NAME working"
    else
        echo "❌ SSH connection to $SERVER_NAME failed"
    fi
done

echo "🎉 SSH key setup completed!"
echo ""
echo "📋 Usage:"
echo "1. Update the EC2 key path in this script: /path/to/your-ec2-key.pem"
echo "2. Run this script first before deployment"
echo "3. Then run deploy-application.sh for SCP deployment"
echo "4. Or run deploy-application-http.sh for HTTP deployment"
