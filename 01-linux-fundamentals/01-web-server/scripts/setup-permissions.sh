#!/bin/bash

# Set proper permissions for web files
echo "Setting up web directory permissions..."

# Set ownership to Apache user
sudo chown -R www-data:www-data /var/www/html/

# Set directory permissions
sudo chmod -R 755 /var/www/html/

# Set file permissions
sudo chmod 644 /var/www/html/*.html

# Restart Apache to apply changes
sudo systemctl restart apache2

echo "Permissions configured successfully!"
