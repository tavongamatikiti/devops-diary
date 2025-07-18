# Solution: Web Server Setup

## Step 1: Launch EC2 Instance

```bash
# Instance configuration
Name: nexus-alpha
Type: t2.micro (free tier)
OS: Ubuntu 22.04 LTS
Security Group: Allow SSH (22), HTTP (80), HTTPS (443)
```

## Step 2: Connect and Update System

```bash
# Connect via SSH
ssh -i your-key.pem ubuntu@your-ec2-ip

# Update system packages
sudo apt update
sudo apt upgrade -y
```

## Step 3: Install Apache

```bash
# Install Apache2
sudo apt install apache2 -y

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2
```

## Step 4: Configure Website

### Remove Default Page
```bash
cd /var/www/html
sudo rm index.html
```

### Create Homepage
```bash
sudo nano index.html
```

Content: Multi-page HTML with cyber theme, navigation menu, and server status information.

### Create Additional Pages
- `about.html` - Technology stack and mission objectives
- `terminal.html` - Command reference guide
- `status.html` - Server status dashboard

## Step 5: Set Permissions

```bash
# Set proper ownership and permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo chmod 644 /var/www/html/*.html

# Restart Apache
sudo systemctl restart apache2
```

## Step 6: Verify Installation

```bash
# Test locally
curl http://localhost

# Check service status
sudo systemctl status apache2

# Monitor access logs
sudo tail -f /var/log/apache2/access.log
```

## Common Issues Encountered

### Permission Denied
**Problem**: Files not accessible by web server
**Solution**: Ensure proper ownership with `chown www-data:www-data`

### Service Won't Start
**Problem**: Apache fails to start
**Solution**: Check configuration with `sudo apache2ctl configtest`

### Security Group Issues
**Problem**: Website not accessible from internet
**Solution**: Verify security group allows HTTP (port 80) from 0.0.0.0/0

## Commands Learned

### Navigation
- `pwd` - Print working directory
- `ls -la` - List files with details
- `cd /path` - Change directory

### File Operations
- `sudo nano filename` - Edit files
- `sudo cp source dest` - Copy files
- `sudo mv old new` - Move/rename files
- `sudo rm filename` - Delete files

### Permissions
- `sudo chmod 755 directory/` - Set directory permissions
- `sudo chmod 644 file.html` - Set file permissions
- `sudo chown user:group file` - Change ownership

### System Monitoring
- `sudo systemctl status service` - Check service status
- `sudo tail -f /var/log/file.log` - Monitor logs
- `ps aux | grep apache2` - Find processes
