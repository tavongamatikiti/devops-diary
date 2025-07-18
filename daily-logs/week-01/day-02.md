# Day 2: PostgreSQL Database Server

## What I Built
- PostgreSQL 16 database server on separate EC2 instance
- Database with users, servers, and server_logs tables
- User authentication system with PHP integration
- Remote database connectivity from nexus-alpha
- Automated backup system with scripts

## Commands Learned

### File Management & Text Processing
- `nano +127 filename` - Open file at specific line number
- `grep -i "pattern" file` - Case-insensitive text search
- `find /path -name "*.conf"` - Find configuration files
- `tail -f /var/log/file.log` - Follow log files in real-time
- `sed -n '125,130p' file` - Print specific line ranges

### PostgreSQL Administration
- `psql -h host -U user -d database` - Remote database connection
- `\l` - List all databases
- `\dt` - List tables in current database
- `\du` - List database users and roles
- `\d table_name` - Describe table structure
- `pg_dump database` - Create database backup

### System Administration
- `sudo systemctl reload service` - Reload service configuration
- `sudo netstat -tlnp | grep 5432` - Check PostgreSQL port
- `sudo -u postgres command` - Execute command as postgres user

## Challenges Encountered

### PostgreSQL Configuration Error
**Problem**: Service failed to start with "invalid IP mask md5" error
**Root Cause**: Incorrect pg_hba.conf syntax - missing subnet mask
**Solution**: Changed `172.31.0.0 md5` to `172.31.0.0/32 md5` (replace with your application server's IP)

### Remote Connection Issues
**Problem**: Could not connect from nexus-alpha to database server
**Root Cause**: PostgreSQL only listening on localhost
**Solution**: Set `listen_addresses = '*'` in postgresql.conf

### Security Group Configuration
**Problem**: Connection timeout from application server
**Root Cause**: Security group not allowing PostgreSQL port 5432
**Solution**: Added inbound rule for port 5432 from private network (172.31.0.0/16)

### Authentication System Integration
**Problem**: PHP couldn't connect to PostgreSQL
**Root Cause**: Missing php-pgsql extension
**Solution**: Installed php-pgsql and restarted Apache

## Key Learnings

### Database Security Best Practices
- Never expose database directly to internet (0.0.0.0/0)
- Use specific IP ranges for database access
- Always use strong passwords for database users
- Regular backups are essential for data protection

### PostgreSQL Configuration
- pg_hba.conf controls client authentication
- postgresql.conf controls server behavior
- Subnet masks (/32) are required for specific IP addresses
- Service restart required after configuration changes

### File Management Skills
- grep with patterns is powerful for finding specific configurations
- tail -f is essential for real-time log monitoring
- find command helps locate configuration files quickly
- Line numbers in nano (+127) speed up file editing

## Infrastructure Progress
- Web server (nexus-alpha) with static content ✓
- Database server (nexus-database) with PostgreSQL ✓
- Cross-server communication established ✓
- Authentication system functional ✓

## Tomorrow's Plan
Set up Node.js application server with PM2 process management and learn process monitoring commands.
