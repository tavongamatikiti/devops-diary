#!/bin/bash

# Process Monitoring Script
echo "🔍 Node.js Process Monitoring"
echo "=============================="

echo "1. PM2 Status:"
pm2 status

echo -e "\n2. Node.js Processes:"
ps aux | grep node | grep -v grep

echo -e "\n3. Port 3000 Usage:"
sudo lsof -i :3000

echo -e "\n4. System Load:"
uptime

echo -e "\n5. Memory Usage:"
free -h

echo -e "\n6. PM2 Memory Usage:"
pm2 show nexus-api 2>/dev/null | grep -E "(memory|cpu)" || echo "PM2 app not running"

echo -e "\n7. Network Connections:"
netstat -tlnp | grep :3000 2>/dev/null || ss -tlnp | grep :3000

echo -e "\n8. Recent Logs (last 10 lines):"
pm2 logs nexus-api --lines 10 2>/dev/null || echo "No PM2 logs available"
