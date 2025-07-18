#!/bin/bash

# Database Setup Script
echo "Setting up nexus_db database..."

# Variables
DB_NAME="nexus_db"
DB_USER="nexus_admin"
DB_PASSWORD="${1:-your_secure_password}"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <database_password>"
    echo "Using default password for demo purposes"
fi

# Create database and user
sudo -u postgres psql << EOSQL
CREATE DATABASE ${DB_NAME};
CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
\q
EOSQL

echo "Database ${DB_NAME} and user ${DB_USER} created successfully!"

# Create tables and sample data
PGPASSWORD=${DB_PASSWORD} psql -h localhost -U ${DB_USER} -d ${DB_NAME} << 'EOSQL'
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
EOSQL

echo "Sample data inserted successfully!"
echo "Tables created: users, servers, server_logs"
