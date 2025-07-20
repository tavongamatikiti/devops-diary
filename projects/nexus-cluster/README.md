# Nexus Cluster Project

Production-ready infrastructure demonstrating DevOps fundamentals.

## Architecture

```
Internet → Nginx Reverse Proxy → Node.js API Server → PostgreSQL Database
           (Port 80)              (Port 3000)        (Port 5432)
                ↓
         Apache Web Server
           (Port 8080)
```

## Components

### Day 1: Web Server (nexus-alpha)
- **Service**: Apache HTTP Server
- **Content**: Multi-page website with authentication
- **Features**: Static content, PHP authentication system
- **Monitoring**: Access logs, system metrics

### Day 2: Database Server (nexus-database)
- **Service**: PostgreSQL 16
- **Database**: nexus_db with user authentication
- **Features**: Remote access, automated backups, user management
- **Security**: Private network access, pg_hba.conf configuration
- **Monitoring**: Connection tracking, query logging

### Day 3: Application Server (nexus-alpha)
- **Service**: Node.js API with Express.js framework
- **Process Manager**: PM2 with cluster mode (2 instances)
- **Reverse Proxy**: Nginx routing API and static content
- **Features**: REST API, database integration, Prometheus metrics
- **Monitoring**: Health checks, application metrics, log aggregation

## Infrastructure Details

### EC2 Instances
- **nexus-alpha**: 10.0.1.xxx (Web server + API server + Reverse proxy)
- **nexus-database**: 10.0.2.xxx (PostgreSQL database)

### Port Configuration
- **Port 80**: Nginx reverse proxy (public)
- **Port 8080**: Apache web server (internal)
- **Port 3000**: Node.js API server (internal)
- **Port 5432**: PostgreSQL database (database server)

### Security Configuration
- SSH access via key pairs
- HTTP/HTTPS public access through Nginx
- Database access restricted to application servers
- Internal communication via private network
- API server not directly accessible from internet

## Database Schema

### Tables Created
- **users**: Authentication system with roles and permissions
- **servers**: Infrastructure inventory and status tracking
- **server_logs**: Centralized logging for all cluster components

### Connection Details
- **Host**: 10.0.2.xxx (nexus-database private IP)
- **Port**: 5432 (PostgreSQL default)
- **Database**: nexus_db
- **User**: nexus_admin
- **Access**: Restricted to application servers via pg_hba.conf

## API Endpoints

### Health & Monitoring
- `GET /health` - Application health check
- `GET /metrics` - Prometheus metrics
- `GET /api/stats` - Database statistics

### Server Management
- `GET /api/servers` - List registered servers
- `POST /api/servers` - Register new server

### Logging System
- `GET /api/logs` - Retrieve system logs
- `POST /api/logs` - Add log entry

## Technology Stack

### Frontend & Web
- **Apache HTTP Server**: Static content serving
- **Nginx**: Reverse proxy and load balancer
- **HTML/CSS/JavaScript**: Multi-page web interface

### Backend & API
- **Node.js v22**: Runtime environment (installed via nvm)
- **Express.js**: Web application framework
- **PM2**: Process manager with clustering
- **Yarn**: Package management

### Database
- **PostgreSQL 16**: Primary database system
- **pg (node-postgres)**: Database client library

### DevOps & Monitoring
- **Prometheus**: Metrics collection
- **prom-client**: Node.js metrics library
- **PM2**: Process monitoring and management

## Current Status
- [x] Web server operational (Day 1)
- [x] Database server operational (Day 2)
- [x] Application server operational (Day 3)
- [ ] Load balancer with multiple instances (Day 4)
- [ ] Monitoring system (Day 5)

## Next Phase: High Availability

Day 4 will implement:
- Multiple application server instances (nexus-beta, nexus-gamma)
- Load balancing across application servers
- Session management for distributed architecture
- Health checks and automatic failover
