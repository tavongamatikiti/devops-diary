# Exercise: Node.js Application Server with Process Management

## Objective
Set up a Node.js API server with PM2 process management, Nginx reverse proxy, and learn advanced process monitoring commands.

## Requirements

### Terminal Skills
- Process management: `ps`, `top`, `htop`, `kill`, `killall`
- Background processes: `nohup`, `screen`, `tmux`, `jobs`, `fg`, `bg`
- Service management: `systemctl`, `journalctl`
- System monitoring: `uptime`, `free`, `iostat`, `vmstat`, `lsof`

### Infrastructure
- Install Node.js and npm on existing server
- Create REST API with database connectivity
- Implement PM2 process manager for production
- Configure Nginx reverse proxy
- Set up process monitoring and logging

### API Requirements
- Health check endpoint (`/health`)
- Database statistics endpoint (`/api/stats`)
- Server management endpoints (`/api/servers`)
- Logging endpoints (`/api/logs`)
- System information endpoint (`/api/system`)
- Prometheus metrics endpoint (`/metrics`)

### Process Management
- PM2 clustering with multiple instances
- Automatic restart on failure
- Log rotation and management
- Process monitoring and alerting

## Deliverables
1. Functional Node.js API server
2. PM2 process management configuration
3. Nginx reverse proxy setup
4. Database connectivity
5. Comprehensive monitoring setup
6. Production-ready configuration

## Success Criteria
- API responds to all endpoints
- PM2 manages processes automatically
- Nginx proxies requests correctly
- Database queries execute successfully
- Process monitoring shows real-time data
- Logs are properly rotated and accessible
