# Nexus Cluster Project

Production-ready infrastructure demonstrating DevOps fundamentals.

## Architecture

```
Internet → Load Balancer → [App Server 1, App Server 2, App Server 3] → Database
                ↓
          Monitoring System
```

## Components

### Day 1: Web Server (nexus-alpha)
- **Service**: Apache HTTP Server
- **Content**: Multi-page website with authentication
- **Features**: Static content, PHP authentication system
- **Monitoring**: Access logs, system metrics

## Infrastructure Details

### EC2 Instances
- **nexus-alpha**: 172.31.31.161 (Primary web/app server)
- **nexus-database**: 172.31.23.224 (PostgreSQL database)

### Security Configuration
- SSH access via key pairs
- HTTP/HTTPS public access
- Database access restricted to application servers
- Internal communication via private network

## Current Status
- [x] Web server operational
- [ ] Database server (Day 2)
- [ ] Application server (Day 3)
- [ ] Load balancer (Day 4)
- [ ] Monitoring (Day 5)
