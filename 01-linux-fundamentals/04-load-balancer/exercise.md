# Exercise: Load Balancer & High Availability Setup

## Objective
Implement load balancing across multiple application server instances with Nginx and learn advanced networking and scaling commands.

## Requirements

### Terminal Skills
- Network monitoring: `iftop`, `ss`, `netstat`, `tcpdump`, `nmap`
- Load testing: `ab`, `curl`, `wget`, `siege`
- Process scaling: `pm2 scale`, cluster management
- System resource monitoring: `vmstat`, `iostat`, `sar`, `dstat`

### Infrastructure
- Set up additional application servers (nexus-beta, nexus-gamma)
- Configure Nginx load balancer with multiple upstream servers
- Implement health checks and failover mechanisms
- Set up session management for distributed architecture

### Load Balancer Requirements
- Round-robin load balancing algorithm
- Health check endpoints for backend servers
- Automatic failover for unhealthy servers
- Request logging and monitoring
- SSL termination (preparation for HTTPS)

### High Availability Features
- Multiple application server instances
- Database connection pooling
- Session persistence or stateless design
- Graceful server shutdown and restart
- Load balancing with weighted distribution

## Deliverables
1. Nginx load balancer configuration
2. Multiple Node.js application server instances
3. Health check and monitoring system
4. Load testing and performance validation
5. Failover testing and recovery procedures
6. Documentation of scaling procedures

## Success Criteria
- Load balancer distributes requests across all healthy servers
- Automatic failover when server becomes unavailable
- No service interruption during server maintenance
- Performance scales linearly with additional servers
- Health checks accurately detect server status
- Load testing shows improved throughput and availability
