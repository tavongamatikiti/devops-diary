# Solution: PostgreSQL Database Server Setup

## Step 1: Launch Database Server

```bash
# Instance configuration
Name: nexus-database
Type: t2.micro
OS: Ubuntu 22.04 LTS
Private IP: 172.31.0.0  # Replace with your database server's private IP
Security Group: SSH (22), PostgreSQL (5432) from private network
```

## Step 2: Install PostgreSQL

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install PostgreSQL and additional tools
sudo apt install postgresql postgresql-contrib postgresql-client -y

# Check installation and version
sudo systemctl status postgresql
sudo -u postgres psql -c "SELECT version();"
```

## Step 3: Initial Database Configuration

```bash
# Switch to postgres user
sudo -i -u postgres

# Access PostgreSQL prompt
psql

# Set password for postgres user
\password postgres

# Create database and user
CREATE DATABASE nexus_db;
CREATE USER nexus_admin WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE nexus_db TO nexus_admin;

# List databases and users
\l
\du

# Exit psql and postgres user
\q
exit
```

## Step 4: Configure Remote Access

### Edit PostgreSQL Configuration
```bash
# Edit main configuration file
sudo nano /etc/postgresql/16/main/postgresql.conf

# Change listen_addresses
listen_addresses = '*'

# Edit client authentication
sudo nano /etc/postgresql/16/main/pg_hba.conf

# Add remote access rule (replace with your application server's IP)
host    nexus_db    nexus_admin    172.31.0.0/32    md5

# Restart PostgreSQL
sudo systemctl restart postgresql@16-main
```

### Verify Configuration
```bash
# Check if PostgreSQL is listening on all interfaces
sudo netstat -tlnp | grep 5432

# Should show: 0.0.0.0:5432
```

## Step 5: Create Database Schema

```bash
# Connect to database
psql -h localhost -U nexus_admin -d nexus_db

# Create tables
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE servers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    ip_address INET,
    server_type VARCHAR(50),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE server_logs (
    id SERIAL PRIMARY KEY,
    server_id INTEGER REFERENCES servers(id),
    log_level VARCHAR(20),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Insert sample data
INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('admin', 'admin@nexus-alpha.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin');

-- Replace the IP addresses below with your actual server IPs
INSERT INTO servers (name, ip_address, server_type) VALUES
('nexus-alpha', '172.31.0.0', 'web'),
('nexus-database', '172.31.0.0', 'database');

INSERT INTO server_logs (server_id, log_level, message) VALUES
(1, 'INFO', 'Apache server started successfully'),
(2, 'INFO', 'PostgreSQL database initialized'),
(1, 'WARNING', 'High memory usage detected');

# View created data
SELECT * FROM users;
SELECT * FROM servers;
SELECT * FROM server_logs;

\q
```

## Step 6: Test Remote Connection

### From nexus-alpha server:
```bash
# Install PostgreSQL client
sudo apt install postgresql-client -y

# Test connection (replace with your database server's IP)
psql -h 172.31.0.0 -U nexus_admin -d nexus_db

# Run test query
SELECT COUNT(*) FROM users;

\q
```

## Step 7: Set Up Backup System

```bash
# Create backup directory
sudo mkdir -p /var/backups/postgresql
sudo chown postgres:postgres /var/backups/postgresql

# Create manual backup
sudo -u postgres pg_dump nexus_db > /var/backups/postgresql/nexus_db_backup_$(date +%Y%m%d_%H%M%S).sql

# Create automated backup script
sudo nano /usr/local/bin/backup-database.sh
```

Backup script content included in scripts directory.

## Step 8: Integrate with Web Server

### Install PHP PostgreSQL Extension (on nexus-alpha)
```bash
# Install PHP PostgreSQL extension
sudo apt install php-pgsql -y

# Restart Apache
sudo systemctl restart apache2
```

### Create Database Status Page
```bash
# Create database status page
sudo nano /var/www/html/db-status.php
```

PHP database status page content included in configs directory.

## Common Issues Encountered

### PostgreSQL Service Failed to Start
**Problem**: Invalid configuration in pg_hba.conf
**Error**: `invalid IP mask "md5": Name or service not known`
**Solution**: Correct format is `host nexus_db nexus_admin 172.31.0.0/32 md5` (replace with your application server's IP)

### Connection Refused
**Problem**: PostgreSQL not listening on network interface
**Solution**: Set `listen_addresses = '*'` in postgresql.conf

### Permission Denied (publickey)
**Problem**: SSH connection issues between servers
**Solution**: Fixed security group rules to allow internal communication

### Authentication Failed
**Problem**: Database user authentication
**Solution**: Ensured proper password and pg_hba.conf configuration

## Commands Learned

### File Management
- `nano +127 filename` - Open file at specific line
- `grep -i "pattern" file` - Case-insensitive search
- `find /path -name "*.conf"` - Find files by pattern
- `tail -f /var/log/file.log` - Follow log files
- `head -20 filename` - Show first 20 lines

### Text Processing
- `sed -n '125,130p' file` - Print specific line range
- `wc -l file` - Count lines in file
- `cat -A file` - Show all characters including invisible ones

### PostgreSQL Commands
- `psql -h host -U user -d database` - Connect to database
- `\l` - List databases
- `\dt` - List tables
- `\du` - List users
- `\d table_name` - Describe table structure

### System Administration
- `sudo systemctl reload service` - Reload configuration
- `sudo netstat -tlnp | grep port` - Check listening ports
- `sudo -u user command` - Run command as different user
