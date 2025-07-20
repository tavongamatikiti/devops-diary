# Solution: Node.js Application Server Setup

## Step 1: Install Node.js and PM2

```bash
# Install Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs -y

# Verify installation
node --version
npm --version

# Install PM2 globally
sudo npm install -g pm2

# Verify PM2 installation
pm2 --version
```

## Step 2: Create Application Directory

```bash
# Create app directory
sudo mkdir -p /opt/nexus-api
sudo chown ubuntu:ubuntu /opt/nexus-api
cd /opt/nexus-api

# Initialize Node.js project
npm init -y

# Install dependencies
npm install express pg cors helmet morgan bcryptjs jsonwebtoken dotenv prom-client
npm install --save-dev nodemon
```

## Step 3: Create Node.js API Application

### Main Application (app.js)
- Express.js server with middleware
- PostgreSQL database connection
- REST API endpoints for server management
- Prometheus metrics integration
- Health check and monitoring endpoints

### Key Features Implemented
- **Database Integration**: PostgreSQL connection with connection pooling
- **Security**: Helmet middleware, CORS configuration
- **Logging**: Morgan HTTP request logging
- **Monitoring**: Custom Prometheus metrics
- **Error Handling**: Comprehensive error management
- **Health Checks**: Application and database health endpoints

## Step 4: Configure PM2 Process Management

### Ecosystem Configuration (ecosystem.config.js)
- Cluster mode for high availability
- Resource limits and restart policies
- Log file configuration
- Environment variable management

### PM2 Commands Used
```bash
# Start application
pm2 start ecosystem.config.js

# Monitor processes
pm2 status
pm2 monit

# View logs
pm2 logs nexus-api

# Restart application
pm2 restart nexus-api

# Save configuration
pm2 save
pm2 startup
```

## Step 5: Configure Nginx Reverse Proxy

### Nginx Configuration
- Upstream configuration for Node.js
- Proxy settings with headers
- Load balancing configuration
- Static file serving
- Error handling

### Port Configuration
- Apache moved to port 8080
- Nginx on port 80
- Node.js on port 3000
- Proper proxy passing between services

## Step 6: Database Integration

### Database Configuration
- Connection to existing PostgreSQL server
- Environment variables for configuration
- Connection pooling for performance
- Error handling for database operations

### API Endpoints Created
- `GET /health` - Application health check
- `GET /api/stats` - Database statistics
- `GET /api/servers` - Server list management
- `POST /api/servers` - Add new servers
- `GET /api/logs` - System logs
- `POST /api/logs` - Add log entries
- `GET /api/system` - System information
- `GET /metrics` - Prometheus metrics

## Process Management Commands Learned

### Process Monitoring
```bash
# View processes
ps aux | grep node
ps aux | grep nginx

# Real-time monitoring
top
htop

# Process tree
pstree

# Kill processes
kill PID
killall node
pkill -f "node app.js"
```

### Background Process Management
```bash
# Run in background
nohup node app.js &

# Screen sessions
screen -S api-session
screen -r api-session

# Job control
jobs
fg %1
bg %1
```

### Service Management
```bash
# Check service status
sudo systemctl status nginx
sudo systemctl status apache2

# Restart services
sudo systemctl restart nginx
sudo systemctl reload nginx

# View service logs
sudo journalctl -u nginx -f
```

### System Monitoring
```bash
# System uptime and load
uptime

# Memory usage
free -h

# Disk I/O
iostat -x 1

# Virtual memory statistics
vmstat 1

# Open files
lsof -i :3000
lsof -p PID

# Network connections
netstat -tulpn | grep :3000
ss -tulpn | grep :3000
```

## Common Issues Encountered

### Port Conflicts
**Problem**: Nginx and Apache both trying to use port 80
**Solution**: Moved Apache to port 8080, configured Nginx as reverse proxy

### PM2 Process Crashes
**Problem**: Node.js process crashing due to unhandled errors
**Solution**: Implemented proper error handling and PM2 restart policies

### Database Connection Errors
**Problem**: Cannot connect to PostgreSQL from application
**Solution**: Updated pg_hba.conf to allow connections from application server

### Permission Issues
**Problem**: PM2 log files permission denied
**Solution**: Configured proper log directories and ownership

## Performance Optimization

### PM2 Configuration
- Cluster mode with multiple instances
- Memory limits and restart policies
- Log rotation configuration
- Process monitoring

### Nginx Optimization
- Upstream configuration
- Connection keep-alive
- Proper header forwarding
- Error page configuration

### Application Optimization
- Database connection pooling
- Async/await for database operations
- Proper error handling
- Resource cleanup

## Monitoring and Logging

### PM2 Monitoring
- Real-time process monitoring with `pm2 monit`
- Log aggregation and rotation
- Process restart tracking
- Memory and CPU usage monitoring

### Application Logging
- HTTP request logging with Morgan
- Database query logging
- Error logging and tracking
- Performance metrics collection

### System Monitoring
- Process resource usage tracking
- Network connection monitoring
- File descriptor usage
- System load monitoring

## Security Considerations

### Application Security
- Helmet middleware for security headers
- CORS configuration
- Input validation and sanitization
- Environment variable management

### Process Security
- Non-root process execution
- Resource limits
- Process isolation
- Log file permissions

## Next Steps

After completing this exercise:
1. Monitor application performance
2. Implement additional API endpoints
3. Add automated testing
4. Configure SSL/TLS certificates
5. Implement load balancing across multiple instances
