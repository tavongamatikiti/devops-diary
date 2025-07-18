# Day 1: Web Server Setup

## What I Built
- Apache web server on EC2 instance
- Multi-page website with cyber theme
- Security group configuration
- Basic system monitoring

## Commands Learned
- Navigation: pwd, ls, cd, mkdir
- File operations: touch, cp, mv, rm
- Permissions: chmod, chown
- System monitoring: systemctl, ps, tail

## Challenges Encountered

### Permission Issues
Initially had problems with file permissions. Apache couldn't read HTML files.
**Solution**: Used `chown www-data:www-data` and proper chmod settings.

### Security Group Configuration
Website wasn't accessible from internet initially.
**Solution**: Added HTTP (port 80) inbound rule to security group.

## Key Learnings
- File permissions are critical for web servers
- Security groups act as virtual firewalls
- systemctl is the modern way to manage services
- Log monitoring is essential for troubleshooting

## Tomorrow's Plan
Set up PostgreSQL database server and learn about database administration.
