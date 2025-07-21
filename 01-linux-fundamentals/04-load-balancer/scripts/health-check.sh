#!/bin/bash

# Health Check Script for All Servers
SERVERS=(
    "nexus-alpha:172.31.31.161:3000"
    "nexus-beta:172.31.45.183:3000"
    "nexus-gamma:172.31.47.48:3000"
    "load-balancer:172.31.35.67:80"
)

echo "🔍 Checking health of all servers..."

for server_info in "${SERVERS[@]}"; do
    IFS=':' read -r name ip port <<< "$server_info"

    if [ "$name" = "load-balancer" ]; then
        endpoint="http://$ip/lb-health"
    else
        endpoint="http://$ip:$port/health"
    fi

    response=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$endpoint")

    if [ "$response" = "200" ]; then
        echo "✅ $name ($ip:$port) - Healthy"
    else
        echo "❌ $name ($ip:$port) - Unhealthy (HTTP $response)"
    fi
done

echo "🎯 Health check completed!"
