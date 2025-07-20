# Day 3 Troubleshooting Guide

## Common Issues and Solutions

### PM2 Process Not Starting

**Symptoms:**
- `pm2 status` shows process as "errored"
- Application not responding on port 3000

**Debugging Steps:**
```bash
# Check PM2 logs
pm2 logs nexus-api

# Check if port is already in use
sudo lsof -i :3000

# Verify application can start manually
cd /opt/nexus-api
node app.js
```

**Common Solutions:**
- Kill conflicting processes on port 3000
- Fix syntax errors in app.js
- Install missing dependencies with `npm install`
- Check environment variables in .env file

### Database Connection Errors

**Symptoms:**
- API returns 500 errors
- "Database connection failed" messages

**Debugging Steps:**
```bash
# Test database connection manually
psql -h 10.0.2.xxx -U nexus_admin -d nexus_db

# Check pg_hba.conf on database server
ssh nexus-database "sudo cat /etc/postgresql/16/main/pg_hba.conf"

# Verify network connectivity
ping 10.0.2.xxx
telnet 10.0.2.xxx 5432
```

**Solutions:**
- Add server IP to pg_hba.conf
- Restart PostgreSQL service
- Check security group rules for port 5432
- Verify database credentials in .env

### Nginx 502 Bad Gateway

**Symptoms:**
- Nginx returns 502 error
- "Bad Gateway" error in browser

**Debugging Steps:**
```bash
# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Verify upstream service is running
curl http://localhost:3000/health

# Test Nginx configuration
sudo nginx -t

# Check if Nginx can reach upstream
sudo netstat -tlnp | grep :3000
```

**Solutions:**
- Start Node.js application with PM2
- Fix Nginx configuration syntax
- Restart Nginx service
- Check upstream server availability

### High Memory Usage

**Symptoms:**
- PM2 shows high memory usage
- Server becomes unresponsive

**Debugging Steps:**
```bash
# Monitor memory usage
free -h
pm2 monit

# Check process memory
ps aux --sort=-%mem | head

# Analyze memory leaks
node --inspect app.js
```

**Solutions:**
- Implement memory limits in PM2
- Fix memory leaks in application code
- Add garbage collection optimization
- Scale horizontally with more instances

### Port Conflicts

**Symptoms:**
- "EADDRINUSE" errors
- Services unable to bind to ports

**Debugging Steps:**
```bash
# Check what's using specific ports
sudo lsof -i :80
sudo lsof -i :3000
sudo lsof -i :8080

# Kill processes using ports
sudo kill $(sudo lsof -t -i:3000)
```

**Solutions:**
- Change service ports in configuration
- Stop conflicting services
- Use different ports for development/production
- Implement proper service shutdown

## Performance Optimization

### PM2 Optimization
```bash
# Optimize for CPU cores
pm2 start ecosystem.config.js

# Monitor performance
pm2 monit

# Reload without downtime
pm2 reload nexus-api
```

### Database Optimization
```bash
# Monitor database connections
psql -h 10.0.2.xxx -U nexus_admin -d nexus_db -c "SELECT * FROM pg_stat_activity;"

# Optimize connection pooling
# Adjust pool settings in app.js
```

### System Monitoring
```bash
# Monitor system resources
htop
iotop
iftop

# Check disk usage
df -h
du -sh /opt/nexus-api/logs/

# Monitor network connections
netstat -i
ss -s
```

## Log Analysis

### PM2 Logs
```bash
# View real-time logs
pm2 logs nexus-api -f

# Export logs
pm2 logs nexus-api --lines 1000 > app-logs.txt

# Clear logs
pm2 flush
```

### System Logs
```bash
# Check system logs
sudo journalctl -f

# Check service-specific logs
sudo journalctl -u nginx -f
sudo journalctl -u apache2 -f

# Check authentication logs
sudo tail -f /var/log/auth.log
```

### Application Logs
```bash
# Check application error logs
tail -f /opt/nexus-api/logs/error.log

# Monitor access patterns
tail -f /var/log/nginx/access.log

# Analyze error patterns
grep "ERROR" /opt/nexus-api/logs/combined.log
```
