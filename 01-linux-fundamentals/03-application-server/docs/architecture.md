# Day 3 Architecture: Application Server

## Overview
Multi-tier application architecture with Node.js API, process management, and reverse proxy.

## Architecture Diagram

```
Internet → Nginx (Port 80) → {
    /api/*     → Node.js API (Port 3000)
    /health    → Node.js API (Port 3000)
    /metrics   → Node.js API (Port 3000)
    /          → Apache (Port 8080)
}

Node.js API → PostgreSQL Database (nexus-database)
```

## Components

### Nginx Reverse Proxy
- **Role**: Load balancer and reverse proxy
- **Port**: 80 (public)
- **Function**: Routes requests to appropriate backend services
- **Configuration**: `/etc/nginx/sites-available/nexus-api`

### Node.js API Server
- **Role**: REST API backend
- **Port**: 3000 (internal)
- **Framework**: Express.js
- **Database**: PostgreSQL connection
- **Process Manager**: PM2 with clustering

### Apache Web Server
- **Role**: Static content server
- **Port**: 8080 (internal)
- **Content**: HTML, CSS, JS files
- **Integration**: Proxied through Nginx

### PostgreSQL Database
- **Role**: Data persistence
- **Location**: nexus-database server
- **Port**: 5432
- **Connection**: Network connection via pg_hba.conf

## Process Management

### PM2 Configuration
- **Instances**: 2 (cluster mode)
- **Auto-restart**: Enabled
- **Log rotation**: Configured
- **Memory limit**: 1GB per instance
- **Monitoring**: Real-time with `pm2 monit`

### Service Dependencies
1. PostgreSQL must be running
2. Nginx configuration must be valid
3. PM2 processes must be healthy
4. Network connectivity between services

## Monitoring Stack

### Process Monitoring
- PM2 built-in monitoring
- System process tracking
- Resource usage monitoring
- Log aggregation

### Application Monitoring
- Health check endpoints
- Prometheus metrics
- Database connection monitoring
- API response time tracking

## Security Considerations

### Network Security
- Internal services on non-public ports
- Nginx as single public entry point
- Database access restricted to application servers

### Application Security
- Environment variable configuration
- Database connection security
- Input validation and sanitization
- Error handling without information disclosure
