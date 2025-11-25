#!/bin/bash
# Complete Flask + Apache Deployment UserData Script
set -e

echo "=== Starting Flask App Deployment ==="

# Variables
APP_NAME="myflaskapp"
APP_DIR="/var/www/$APP_NAME"
DB_URL="mysql+pymysql://dbadmin:dbpassword@python-mysql-db-proj-db.cpuoe0guilc0.us-east-2.rds.amazonaws.com:3306/flaskdb"

# Update and install dependencies
sudo apt update
sudo apt install -y apache2 apache2-dev python3 python3-pip python3-venv mysql-client

# Enable Apache modules
sudo a2enmod wsgi
sudo a2enmod headers

# Create application directory
sudo mkdir -p $APP_DIR
sudo mkdir -p $APP_DIR/templates

# Clone your project (replace with your actual repo)
sudo git clone https://github.com/your-username/Cloud-Native-Drive.git /tmp/project
sudo cp -r /tmp/project/projectpy-mysql-db/pyproject-application/* $APP_DIR/

# Set permissions
sudo chown -R ubuntu:ubuntu $APP_DIR
sudo chmod -R 755 $APP_DIR

# Create virtual environment
cd $APP_DIR
python3 -m venv venv

# Install Python dependencies
./venv/bin/pip install flask flask-sqlalchemy flask-login flask-admin werkzeug pymysql

# Add Apache WSGI line to app.py
if ! grep -q "application = app" app.py; then
    echo "else:
    application = app" >> app.py
fi

# Create WSGI file
cat > $APP_DIR/myapp.wsgi << 'EOF'
import sys
import os

# Set environment variables
os.environ['DATABASE_URL'] = 'mysql+pymysql://dbadmin:dbpassword@python-mysql-db-proj-db.cpuoe0guilc0.us-east-2.rds.amazonaws.com:3306/flaskdb'
os.environ['SECRET_KEY'] = 'your-secret-key-change-in-production-123'

sys.path.insert(0, '/var/www/myflaskapp')
sys.path.insert(0, '/var/www/myflaskapp/venv/lib/python3.12/site-packages')

from app import app as application
EOF

# Create Apache configuration
sudo tee /etc/apache2/sites-available/$APP_NAME.conf > /dev/null << EOF
<VirtualHost *:80>
    ServerName localhost
    WSGIDaemonProcess $APP_NAME python-path=$APP_DIR python-home=$APP_DIR/venv
    WSGIScriptAlias / /var/www/$APP_NAME/myapp.wsgi
    
    <Directory $APP_DIR>
        WSGIProcessGroup $APP_NAME
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/${APP_NAME}_error.log
    CustomLog \${APACHE_LOG_DIR}/${APP_NAME}_access.log combined
</VirtualHost>
EOF

# Set final permissions
sudo chown -R www-data:www-data $APP_DIR
sudo chmod -R 755 $APP_DIR
sudo chmod 644 $APP_DIR/*.wsgi
sudo chmod 644 $APP_DIR/*.py

# Enable site and restart Apache
sudo a2dissite 000-default
sudo a2ensite $APP_NAME
sudo systemctl restart apache2

# Wait for Apache to start
sleep 10

# Create database and tables
mysql -h python-mysql-db-proj-db.cpuoe0guilc0.us-east-2.rds.amazonaws.com -u dbadmin -pdbpassword -e "CREATE DATABASE IF NOT EXISTS flaskdb;" 2>/dev/null || true

# Initialize database tables
cd $APP_DIR
./venv/bin/python -c "
import os
os.environ['DATABASE_URL'] = 'mysql+pymysql://dbadmin:dbpassword@python-mysql-db-proj-db.cpuoe0guilc0.us-east-2.rds.amazonaws.com:3306/flaskdb'
os.environ['SECRET_KEY'] = 'your-secret-key-change-in-production-123'
from app import app, db, User
with app.app_context():
    db.create_all()
    if not User.query.filter_by(username='admin').first():
        admin_user = User(username='admin', email='admin@example.com', role='admin')
        admin_user.set_password('admin123')
        db.session.add(admin_user)
        db.session.commit()
    print('Database initialized successfully!')
"

echo "=== Deployment Complete ==="
echo "Application URL: http://$(curl -s ifconfig.me)"
echo "Default login: admin / admin123"
echo "Health check: curl http://localhost/health"
