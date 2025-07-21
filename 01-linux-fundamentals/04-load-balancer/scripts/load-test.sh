#!/bin/bash

# Load Testing Script for Load Balancer
LOAD_BALANCER_IP="172.31.35.67"  # Update with your load balancer IP

echo "🚀 Starting load testing..."

# Test single request
echo "1. Testing single request:"
curl -s http://$LOAD_BALANCER_IP/health

# Test multiple sequential requests
echo -e "\n2. Testing load distribution (10 requests):"
for i in {1..10}; do
    curl -s http://$LOAD_BALANCER_IP/api/stats | grep -o '"server":"[^"]*"' || echo "Request $i"
done

# Test concurrent requests
echo -e "\n3. Testing concurrent requests:"
seq 1 20 | xargs -n1 -P5 -I{} curl -s http://$LOAD_BALANCER_IP/health

# Apache Bench test
echo -e "\n4. Apache Bench test (100 requests, 10 concurrent):"
ab -n 100 -c 10 http://$LOAD_BALANCER_IP/health

echo "✅ Load testing completed!"
