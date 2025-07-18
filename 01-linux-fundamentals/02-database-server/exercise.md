# Exercise: PostgreSQL Database Server

## Objective
Set up PostgreSQL database server with user authentication system and learn file management commands.

## Requirements

### Terminal Skills to Learn
- Text editors: `nano`, `vim` basics
- File content operations: `cat`, `less`, `head`, `tail`
- File searching: `find`, `grep` with patterns
- Text processing: `sort`, `uniq`, `wc`, `cut`
- Advanced file permissions and ownership

### Infrastructure Setup
- Launch separate EC2 instance for database (or use existing)
- Install PostgreSQL 16
- Configure remote access and authentication
- Create database and users with proper permissions
- Set up backup and restore procedures

### Database Requirements
- Database: `nexus_db`
- Admin user: `nexus_admin` with full privileges
- Sample tables: users, servers, server_logs
- Authentication system integration
- Remote access from application servers

### Security Configuration
- Configure pg_hba.conf for network access
- Set up proper user authentication
- Database connection from nexus-alpha server
- Security group rules for PostgreSQL (port 5432)

## Deliverables
1. Running PostgreSQL server
2. Database with sample data
3. User authentication system
4. Remote connectivity from web server
5. PHP-based database status page

## Success Criteria
- PostgreSQL accessible from nexus-alpha
- Authentication system working
- Database queries execute successfully
- Backup procedures in place
