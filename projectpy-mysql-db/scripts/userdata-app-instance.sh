#!/bin/bash
cd /home/ubuntu

# Update system and install dependencies
yes | sudo apt update
yes | sudo apt install -y python3 python3-pip git apache2 libapache2-mod-wsgi-py3

# Clone your application repository
git clone https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME.git
cd pyproject-application

# Install Python dependencies
pip3 install -r requirements.txt

# Replace the database URI with your actual RDS details
sed -i "s|mysql://username:password@localhost:3306/flaskdb|mysql://YOUR_RDS_USERNAME:YOUR_RDS_PASSWORD@YOUR_RDS_ENDPOINT:3306/YOUR_DATABASE_NAME|g" app.py

# Create WSGI entry point for Apache
sudo tee /home/ubuntu/pyproject-application/app.wsgi > /dev/null <<EOF
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/home/ubuntu/pyproject-application')

from app import app as application
EOF

# Configure Apache to serve Flask app
sudo tee /etc/apache2/sites-available/flask-app.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName your-ec2-public-ip
    
    # WSGI configuration
    WSGIDaemonProcess flaskapp user=www-data group=www-data threads=5
    WSGIScriptAlias / /home/ubuntu/pyproject-application/app.wsgi

    <Directory /home/ubuntu/Ypyproject-application>
        WSGIProcessGroup flaskapp
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
    </Directory>

    # Static files
    Alias /static /home/ubuntu/pyproject-application/static
    <Directory /home/ubuntu/pyproject-application/static>
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/flask-app-error.log
    CustomLog \${APACHE_LOG_DIR}/flask-app-access.log combined
</VirtualHost>
EOF

# Enable Apache modules and site
sudo a2enmod wsgi
sudo a2ensite flask-app
sudo a2dissite 000-default.conf

# Set proper permissions
sudo chown -R www-data:www-data /home/ubuntu/pyproject-application
sudo chmod -R 755 /home/ubuntu/pyproject-application

# Restart Apache
sudo systemctl restart apache2
sudo systemctl enable apache2

echo "================================================"
echo "🚀 Production Flask Deployment Complete!"
echo "================================================"
echo "Application URL: http://\$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo ""
echo "📋 Default Login Credentials:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "🌐 Served by: Apache Web Server (Production Ready)"
echo "================================================"