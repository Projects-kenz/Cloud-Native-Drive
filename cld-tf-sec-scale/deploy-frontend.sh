#!/bin/bash
# ============================================================
# deploy-frontend.sh  –  Run on your EC2 instance
# ============================================================
set -e

echo "==> Installing Node 20 & nginx"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs nginx

echo "==> Building Angular"
cd /home/ubuntu/demo-app/frontend
npm install
npm run build:prod

echo "==> Copying dist to nginx"
sudo rm -rf /var/www/html/*
sudo cp -r dist/demo-frontend/browser/* /var/www/html/

echo "==> Configuring nginx for Angular routing"
sudo bash -c 'cat > /etc/nginx/sites-available/default << EOF
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;

    # Angular HTML5 routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Proxy API calls to .NET backend
    location /api/ {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF'

sudo nginx -t
sudo systemctl restart nginx

echo "==> Frontend live at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
