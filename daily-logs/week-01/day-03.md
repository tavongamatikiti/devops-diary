# Day 3: Node.js Application Server with Process Management

## What I Built
- Node.js API server with Express.js framework
- PM2 process manager with clustering (2 instances)
- Nginx reverse proxy configuration
- Database connectivity to PostgreSQL
- REST API endpoints for server management
- Prometheus metrics integration

## Commands Learned

### Node.js & Package Management
- `nvm install 22` - Install Node.js version 22
- `nvm use 22` - Switch to Node.js version 22
- `nvm current` - Check current Node.js version
- `corepack enable yarn` - Enable Yarn package manager
- `yarn add package-name` - Install production dependencies
- `yarn add --dev package-name` - Install development dependencies
- `yarn install` - Install all dependencies from package.json

### Process Management with PM2
- `pm2 start ecosystem.config.js` - Start application with config
- `pm2 status` - Check running processes
- `pm2 monit` - Real-time process monitoring
- `pm2 logs nexus-api` - View application logs
- `pm2 restart nexus-api` - Restart application
- `pm2 reload nexus-api` - Zero-downtime restart
- `pm2 stop nexus-api` - Stop application
- `pm2 save` - Save current process list
- `pm2 startup` - Generate startup script

### System Process Monitoring
- `ps aux | grep node` - Find Node.js processes
- `ps aux | grep nginx` - Find Nginx processes
- `pstree` - Display process tree
- `top` - Real-time process monitoring
- `htop` - Enhanced process monitoring
- `lsof -i :3000` - Check what's using port 3000
- `netstat -tlnp | grep :3000` - Network connections on port 3000
- `ss -tlnp | grep :3000` - Modern netstat alternative

### Service Management
- `sudo systemctl restart nginx` - Restart Nginx service
- `sudo systemctl reload nginx` - Reload Nginx configuration
- `sudo systemctl status nginx` - Check Nginx status
- `sudo nginx -t` - Test Nginx configuration syntax
- `sudo journalctl -u nginx -f` - Follow Nginx service logs

### Background Process Control
- `nohup node app.js &` - Run process in background
- `jobs` - List active jobs
- `fg %1` - Bring job to foreground
- `bg %1` - Send job to background
- `disown` - Remove job from shell job table

## Challenges Encountered

### Port Conflicts
**Problem**: Apache and Nginx both trying to use port 80
**Solution**: Moved Apache to port 8080, configured Nginx as reverse proxy on port 80
**Commands Used**:
```bash
sudo nano /etc/apache2/ports.conf  # Changed Listen 80 to Listen 8080
sudo systemctl restart apache2
sudo nano /etc/nginx/sites-available/nexus-api  # Configured reverse proxy
```

### PM2 Process Management Issues
**Problem**: Node.js application crashing on startup due to database connection errors
**Solution**: Fixed database connection configuration and implemented proper error handling
**Commands Used**:
```bash
pm2 logs nexus-api  # Debug application logs
pm2 restart nexus-api  # Restart after fixes
pm2 monit  # Monitor resource usage
```

### Database Connection Permissions
**Problem**: Node.js couldn't connect to PostgreSQL database
**Solution**: Updated pg_hba.conf to allow connections from application server
**Commands Used**:
```bash
ssh nexus-database "sudo nano /etc/postgresql/16/main/pg_hba.conf"
# Added: host nexus_db nexus_admin 172.31.31.161/32 md5
sudo systemctl restart postgresql@16-main
psql -h 172.31.23.224 -U nexus_admin -d nexus_db -c "SELECT 1;"  # Test connection
```

### Nginx Reverse Proxy Configuration
**Problem**: 502 Bad Gateway errors when accessing API through Nginx
**Solution**: Fixed upstream configuration and proxy headers
**Commands Used**:
```bash
sudo nginx -t  # Test configuration
sudo tail -f /var/log/nginx/error.log  # Debug errors
curl http://localhost:3000/health  # Test upstream directly
sudo systemctl reload nginx  # Apply configuration changes
```

## Key Learnings

### Process Management Best Practices
- PM2 cluster mode provides high availability with automatic restart
- Process monitoring is essential for production applications
- Log aggregation helps with debugging distributed applications
- Resource limits prevent runaway processes from affecting system

### Reverse Proxy Architecture
- Nginx as reverse proxy provides load balancing and SSL termination
- Proper header forwarding maintains client information
- Health checks ensure traffic only goes to healthy backends
- Upstream configuration enables easy scaling

### Database Integration Patterns
- Connection pooling improves performance and resource usage
- Environment variables keep credentials secure
- Database health checks prevent application startup without DB
- Proper error handling provides graceful degradation

### System Administration Skills
- Service management with systemctl for production reliability
- Log file analysis for troubleshooting and monitoring
- Network troubleshooting with lsof, netstat, and ss commands
- Process monitoring and resource management

## Performance Observations

### Application Performance
- **Response Time**: API health check responds in ~20ms
- **Memory Usage**: Each PM2 instance uses ~45MB RAM
- **CPU Usage**: <2% under normal load with 2 instances
- **Throughput**: Handles 100+ concurrent requests without issues

### System Resource Usage
- **Total Memory**: Application uses ~90MB total (2 instances)
- **Process Count**: 2 Node.js workers + 1 PM2 master process
- **Network Connections**: ~6 active connections to database
- **File Descriptors**: ~25 open files per process

## API Endpoints Implemented

### Health & Monitoring
- `GET /health` - Application health check (returns server status)
- `GET /metrics` - Prometheus metrics (Node.js and custom metrics)
- `GET /api/stats` - Database and system statistics

### Server Management
- `GET /api/servers` - List all registered servers
- `POST /api/servers` - Register new server
- `GET /api/servers/:id` - Get specific server details

### Logging System
- `GET /api/logs` - Retrieve system logs with pagination
- `POST /api/logs` - Add new log entry
- `GET /api/logs/search?query=term` - Search logs

### System Information
- `GET /api/system` - Server system information (CPU, memory, uptime)

## Architecture Decisions

### Technology Stack Choices
- **Express.js**: Lightweight, fast, and well-documented web framework
- **PM2**: Production-grade process manager with clustering support
- **PostgreSQL**: Robust relational database with excellent Node.js support
- **Nginx**: High-performance reverse proxy and load balancer

### Security Implementations
- **Helmet middleware**: Sets security headers automatically
- **CORS configuration**: Controls cross-origin requests
- **Environment variables**: Keeps sensitive data out of code
- **Input validation**: Prevents SQL injection and XSS attacks

### Monitoring Integration
- **Prometheus metrics**: Custom application and business metrics
- **Health check endpoints**: Kubernetes-ready health monitoring
- **Structured logging**: JSON-formatted logs for easy parsing
- **Error tracking**: Comprehensive error logging and reporting

## Tomorrow's Plan
Implement load balancing across multiple application server instances and set up high availability with automatic failover. This will involve:
- Setting up additional application servers (nexus-beta, nexus-gamma)
- Configuring Nginx load balancer with multiple upstream servers
- Implementing session management for distributed architecture
- Setting up health checks and automatic failover mechanisms

## Infrastructure Status After Day 3

### Servers in Use
- **nexus-alpha (172.31.31.161)**: Web server + API server + Reverse proxy
- **nexus-database (172.31.23.224)**: PostgreSQL database server

### Services Running
- **Port 80**: Nginx reverse proxy (public)
- **Port 8080**: Apache web server (internal)
- **Port 3000**: Node.js API server (internal)
- **Port 5432**: PostgreSQL database (database server)

### Next Integration Points
- Load balancer setup for high availability
- Multiple application server instances
- Session management and state synchronization
- Enhanced monitoring and alerting

The infrastructure is now ready for horizontal scaling and load balancing implementation.
