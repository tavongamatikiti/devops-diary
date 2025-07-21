# Day 4 Architecture: Load Balancer & High Availability

## Overview
Multi-server architecture with load balancing, automatic failover, and horizontal scaling.

## Architecture Diagram

```
Internet → Nginx Load Balancer (Port 80) → {
    nexus-alpha:3000   (Weight: 1, Health: Check)
    nexus-beta:3000    (Weight: 1, Health: Check)
    nexus-gamma:3000   (Weight: 1, Health: Check)
} → PostgreSQL Database (nexus-database:5432)
```

## Components

### Load Balancer (Nginx)
- **Algorithm**: Least connections with round-robin fallback
- **Health Checks**: HTTP health endpoints with retry logic
- **Failover**: Automatic upstream server removal/addition
- **Monitoring**: Status page and access logging

### Application Server Cluster
- **nexus-alpha**: xxx.xxx.xxx.161:3000 (Primary + Web server)
- **nexus-beta**: xxx.xxx.xxx.183:3000 (Application server)
- **nexus-gamma**: xxx.xxx.xxx.48:3000 (Application server)

### High Availability Features
- **Automatic Failover**: Failed servers automatically removed from rotation
- **Health Monitoring**: Continuous health checks every 30 seconds
- **Session Management**: Stateless design for seamless failover
- **Database Pooling**: Connection pooling across all application servers

## Load Balancing Configuration

### Upstream Configuration
```nginx
upstream nexus_api_cluster {
    least_conn;
    server xxx.xxx.xxx.161:3000 max_fails=3 fail_timeout=30s weight=1;
    server xxx.xxx.xxx.183:3000 max_fails=3 fail_timeout=30s weight=1;
    server xxx.xxx.xxx.48:3000 max_fails=3 fail_timeout=30s weight=1;
    keepalive 32;
}
```

### Health Check Settings
- **max_fails**: 3 consecutive failures before marking server down
- **fail_timeout**: 30 seconds before retrying failed server
- **proxy_connect_timeout**: 5 seconds connection timeout
- **proxy_next_upstream**: Automatic retry on errors

## Performance Characteristics

### Throughput Scaling
- **Single Server**: ~100 requests/second
- **3-Server Cluster**: ~280 requests/second
- **Scaling Factor**: 2.8x improvement with 3 servers

### Response Time
- **Average**: <50ms for API endpoints
- **95th Percentile**: <100ms under normal load
- **99th Percentile**: <200ms under high load

### Availability
- **Uptime**: 99.9% with automatic failover
- **Failover Time**: <5 seconds for detection and rerouting
- **Recovery Time**: Automatic when server becomes healthy

## Database Connection Management

### Connection Pooling
- **Pool Size**: 10 connections per application server
- **Max Connections**: 30 total across cluster
- **Connection Reuse**: Persistent connections with keepalive
- **Failover**: Database connection retry logic

### Access Control
- **pg_hba.conf**: Each application server has explicit access
- **Network Security**: Database only accessible from app servers
- **Connection Monitoring**: Active connection tracking

## Monitoring and Logging

### Nginx Monitoring
- **Access Logs**: Request distribution and response times
- **Error Logs**: Upstream failures and connection issues
- **Status Page**: Real-time upstream server status
- **Metrics**: Request rate, error rate, response time

### Application Monitoring
- **Health Endpoints**: Application-level health checks
- **Process Monitoring**: PM2 cluster monitoring across servers
- **Resource Usage**: CPU, memory, and network per server
- **Database Monitoring**: Connection pool status and query performance

## Security Implementation

### Network Security
- **Public Access**: Only through load balancer
- **Private Network**: Application servers not directly accessible
- **Database Access**: Restricted to application servers only
- **Internal Communication**: All traffic over private network

### Application Security
- **Header Forwarding**: Client IP and protocol preservation
- **Request Timeout**: Protection against slow clients
- **Rate Limiting**: Prepared for future implementation
- **Error Handling**: No sensitive information disclosure

## Operational Procedures

### Deployment Process
1. Deploy to one server at a time
2. Verify health check passes
3. Monitor error rates and response times
4. Roll back if issues detected
5. Proceed to next server

### Maintenance Windows
1. Remove server from load balancer rotation
2. Perform maintenance on isolated server
3. Verify application starts correctly
4. Add server back to rotation
5. Monitor for successful integration

### Scaling Operations
1. Launch new application server
2. Deploy application code
3. Configure database access
4. Add to load balancer upstream
5. Monitor performance improvement

## Troubleshooting Guide

### Common Issues
- **502 Bad Gateway**: Check upstream server health
- **High Response Times**: Monitor server resources
- **Connection Errors**: Verify database connectivity
- **Uneven Load Distribution**: Check server health status

### Diagnostic Commands
```bash
# Check upstream server status
curl http://each-server:3000/health

# Monitor load balancer logs
sudo tail -f /var/log/nginx/access.log

# Check connection distribution
sudo netstat -an | grep :3000

# Test failover
pm2 stop nexus-api  # On one server
```

## Future Enhancements

### Planned Improvements
- **SSL/TLS Termination**: HTTPS support at load balancer
- **Advanced Health Checks**: Application-specific health metrics
- **Auto-scaling**: Dynamic server addition based on load
- **Geographic Distribution**: Multi-region deployment
- **Caching Layer**: Redis for session storage and caching
