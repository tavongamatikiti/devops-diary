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
- **nexus-alpha**: 172.31.0.0 (Primary web/app server)
- **nexus-database**: 172.31.0.0 (PostgreSQL database)

**Note**: Replace the IP addresses above with your own private or public IP addresses when implementing this infrastructure.

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

### Day 2: Database Server (nexus-database)
- **Service**: PostgreSQL 16
- **Database**: nexus_db with user authentication
- **Features**: Remote access, automated backups, PHP integration
- **Security**: Private network access only, user-based authentication
- **Monitoring**: Connection tracking, query logging

## Database Schema

### Tables Created
- **users**: Authentication system with roles and permissions
- **servers**: Infrastructure inventory and status tracking
- **server_logs**: Centralized logging for all cluster components

### Connection Details
- **Host**: 172.31.0.0 (private IP - replace with your actual database server IP)
- **Port**: 5432 (PostgreSQL default)
- **Database**: nexus_db
- **Access**: Restricted to application servers only

## Current Status
- [x] Web server operational (Day 1)
- [x] Database server operational (Day 2)
- [ ] Application server (Day 3)
- [ ] Load balancer (Day 4)
- [ ] Monitoring (Day 5)
