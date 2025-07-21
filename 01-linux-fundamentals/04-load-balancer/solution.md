# Solution: Load Balancer & High Availability Setup

## Step 1: Launch Additional Application Servers

```bash
# Launch new EC2 instances for nexus-beta and nexus-gamma
# Instance configuration same as nexus-alpha:
# - Type: t2.micro
# - OS: Ubuntu 22.04 LTS
# - Security Group: Same as nexus-alpha
# - Key Pair: Same SSH key

# Connect to each new server and set up basic environment
ssh -i your-key.pem ubuntu@nexus-beta-ip
ssh -i your-key.pem ubuntu@nexus-gamma-ip
```

## Step 2: Install Node.js on Additional Servers

```bash
# On each new server (nexus-beta, nexus-gamma):

# Install nvm and Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22
nvm use 22

# Enable Yarn and install PM2
corepack enable yarn
npm install -g pm2

# Verify installations
node -v
yarn -v
pm2 --version
```

## Step 3: Deploy Application to Additional Servers

### Copy Application Files
```bash
# Method 1: Using SCP with SSH Key (Recommended)

# First, set up SSH keys for server-to-server communication
ssh-keygen -t rsa -b 2048  # Generate SSH key pair
# Copy public key to target servers (using your EC2 key)
cat ~/.ssh/id_rsa.pub | ssh -i your-ec2-key.pem ubuntu@nexus-beta "cat >> ~/.ssh/authorized_keys"
cat ~/.ssh/id_rsa.pub | ssh -i your-ec2-key.pem ubuntu@nexus-gamma "cat >> ~/.ssh/authorized_keys"

# Create and deploy application package
cd /opt/nexus-api
tar czf nexus-api-deployment.tar.gz --exclude=node_modules --exclude=logs/*.log .

# Copy to target servers via SCP
scp nexus-api-deployment.tar.gz ubuntu@172.31.45.183:/tmp/
scp nexus-api-deployment.tar.gz ubuntu@172.31.47.48:/tmp/

# Method 2: Alternative HTTP Server Method
# Create application package
tar czf nexus-api-deployment.tar.gz --exclude=node_modules .

# Serve files via HTTP
python3 -m http.server 8000 &

# On target servers, download the package
curl -O http://172.31.31.161:8000/nexus-api-deployment.tar.gz
```

### Configure Environment Variables
```bash
# On nexus-beta:
echo "SERVER_NAME=nexus-beta" >> /opt/nexus-api/.env

# On nexus-gamma:
echo "SERVER_NAME=nexus-gamma" >> /opt/nexus-api/.env

# Start applications
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

## Step 4: Configure Load Balancer

### Update Nginx Configuration
```bash
# On nexus-alpha (or dedicated load balancer server)
sudo nano /etc/nginx/sites-available/load-balancer
```

**Complete Load Balancer Configuration:**
```nginx
upstream nexus_api_cluster {
    least_conn;

    # Application server instances with health checks
    server 172.31.31.161:3000 max_fails=3 fail_timeout=30s weight=1;  # nexus-alpha
    server 172.31.45.183:3000 max_fails=3 fail_timeout=30s weight=1;  # nexus-beta
    server 172.31.47.48:3000 max_fails=3 fail_timeout=30s weight=1;   # nexus-gamma

    keepalive 32;
}

upstream nexus_web_cluster {
    # Static content servers (if needed)
    server 172.31.31.161:8080 weight=1;  # nexus-alpha Apache
}

server {
    listen 80;
    server_name your-load-balancer-ip;

    # Security headers
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Health check endpoint for load balancer itself
    location /lb-health {
        access_log off;
        return 200 "Load Balancer OK\n";
        add_header Content-Type text/plain;
    }

    # API endpoints with load balancing
    location /api/ {
        proxy_pass http://nexus_api_cluster;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;

        # Timeouts
        proxy_connect_timeout 5s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;

        # Retry logic
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;
        proxy_next_upstream_tries 3;
        proxy_next_upstream_timeout 10s;
    }

    # Health check endpoint for API servers
    location /health {
        proxy_pass http://nexus_api_cluster;
        proxy_set_header Host $host;
        access_log off;
    }

    # Metrics endpoint with load balancing
    location /metrics {
        proxy_pass http://nexus_api_cluster;
        proxy_set_header Host $host;
    }

    # Web interface (static content)
    location / {
        proxy_pass http://nexus_web_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Status page for monitoring
    location /nginx-status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        allow 172.31.0.0/16;
        deny all;
    }

    # Custom error pages
    error_page 502 503 504 /50x.html;
    location = /50x.html {
        root /var/www/html;
        internal;
    }

    # Logs
    access_log /var/log/nginx/load-balancer-access.log;
    error_log /var/log/nginx/load-balancer-error.log;
}
```

## Step 5: Enable Load Balancer Configuration

```bash
# Enable the load balancer site
sudo ln -sf /etc/nginx/sites-available/load-balancer /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

# Verify status
sudo systemctl status nginx
```

## Step 6: Database Access Configuration

### Update PostgreSQL Access
```bash
# On nexus-database, update pg_hba.conf for new servers
sudo nano /etc/postgresql/16/main/pg_hba.conf

# Add entries for new servers:
# host nexus_db nexus_admin 172.31.45.183/32 md5  # nexus-beta
# host nexus_db nexus_admin 172.31.47.48/32 md5   # nexus-gamma

# Restart PostgreSQL
sudo systemctl restart postgresql@16-main
```

### Test Database Connectivity
```bash
# From each application server, test database connection
psql -h 172.31.23.224 -U nexus_admin -d nexus_db -c "SELECT current_database(), current_user;"
```

## Load Balancing Commands Learned

### Network Monitoring
```bash
# Monitor network interfaces
iftop -i eth0

# View network connections
ss -tuln
ss -anp | grep :80

# Network statistics
netstat -i
netstat -s

# Capture network traffic
sudo tcpdump -i eth0 port 80

# Scan for open ports
nmap -p 1-1000 localhost
```

### Load Testing
```bash
# Apache Bench testing
ab -n 1000 -c 10 http://your-load-balancer/health

# Curl load testing
for i in {1..10}; do curl -s http://your-load-balancer/api/stats; done

# Multiple concurrent requests
seq 1 100 | xargs -n1 -P10 curl -s http://your-load-balancer/health

# Advanced load testing with siege
siege -c 25 -t 60s http://your-load-balancer/api/stats
```

### Process Scaling
```bash
# Scale PM2 processes
pm2 scale nexus-api 4      # Scale to 4 instances
pm2 scale nexus-api +2     # Add 2 more instances
pm2 scale nexus-api -1     # Remove 1 instance

# Monitor process distribution
pm2 monit
pm2 list

# Reload with zero downtime
pm2 reload nexus-api
```

### System Resource Monitoring
```bash
# Virtual memory statistics
vmstat 1 10

# I/O statistics
iostat -x 1 5

# System activity reporter
sar -u 1 10    # CPU usage
sar -r 1 10    # Memory usage
sar -n DEV 1 5 # Network statistics

# Comprehensive system stats
dstat -cdngy 1
```

## Common Issues Encountered

### Upstream Server Connection Issues
**Problem**: 502 Bad Gateway errors from load balancer
**Solution**: Verify upstream servers are running and accessible
```bash
# Check if services are running on all servers
curl http://172.31.31.161:3000/health
curl http://172.31.45.183:3000/health
curl http://172.31.47.48:3000/health

# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

### Database Connection Pool Exhaustion
**Problem**: Database connection errors under high load
**Solution**: Optimize connection pooling settings
```bash
# Monitor database connections
psql -h 172.31.23.224 -U nexus_admin -d nexus_db -c "SELECT count(*) FROM pg_stat_activity;"

# Adjust pool settings in application configuration
```

### Session Persistence Issues
**Problem**: User sessions not maintained across servers
**Solution**: Implement stateless authentication or session store
```bash
# Use JWT tokens for stateless authentication
# Or implement Redis session store for shared sessions
```

### Health Check False Positives
**Problem**: Healthy servers marked as down
**Solution**: Tune health check parameters
```bash
# Adjust timeouts in Nginx configuration
# max_fails=3 fail_timeout=30s
# proxy_connect_timeout 5s
```

## Performance Optimization

### Nginx Optimization
```bash
# Optimize worker processes
grep processor /proc/cpuinfo | wc -l  # Get CPU count
sudo nano /etc/nginx/nginx.conf       # Set worker_processes

# Enable gzip compression
# Enable HTTP/2 if using SSL
# Optimize buffer sizes
```

### Application Optimization
```bash
# Monitor application performance
pm2 monit

# Analyze response times
curl -w "@curl-format.txt" http://your-load-balancer/api/stats
```

### Database Optimization
```bash
# Monitor database performance
psql -h 172.31.23.224 -U nexus_admin -d nexus_db -c "SELECT * FROM pg_stat_database WHERE datname = 'nexus_db';"

# Optimize connection pooling
# Implement query optimization
```

## Load Testing Results

### Performance Benchmarks
- **Single Server**: ~100 requests/second
- **Load Balanced (3 servers)**: ~280 requests/second
- **Response Time**: <50ms for API endpoints
- **Failover Time**: <5 seconds for automatic recovery

### Scaling Validation
- Linear performance improvement with additional servers
- No service interruption during server maintenance
- Automatic recovery from server failures
- Load distribution working correctly across all servers

## High Availability Validation

### Failover Testing
```bash
# Test server failure scenario
ssh nexus-beta "pm2 stop nexus-api"

# Monitor load balancer response
while true; do curl -s http://your-load-balancer/health; sleep 1; done

# Verify traffic redistribution
sudo tail -f /var/log/nginx/access.log
```

### Recovery Testing
```bash
# Restart failed server
ssh nexus-beta "pm2 start nexus-api"

# Verify automatic recovery
curl http://172.31.45.183:3000/health

# Check load balancer picks up healthy server
```

## Security Considerations

### Network Security
- Load balancer as single public entry point
- Application servers not directly accessible from internet
- Database access restricted to application servers only
- Internal communication on private network

### Application Security
- Health check endpoints without sensitive information
- Proper error handling without information disclosure
- Request timeout limits to prevent resource exhaustion
- Rate limiting considerations for future implementation

## Next Steps for Day 5

After completing load balancing setup:
1. Implement comprehensive monitoring system
2. Set up alerting for server failures
3. Add performance metrics and dashboards
4. Implement automated scaling based on load
5. Add SSL/TLS termination at load balancer
