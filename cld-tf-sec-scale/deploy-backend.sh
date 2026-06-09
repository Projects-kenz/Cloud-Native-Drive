#!/bin/bash
# ============================================================
# deploy-backend.sh  –  Run on your EC2 instance (Ubuntu 22/24)
# ============================================================
set -e

echo "==> Installing .NET 8 SDK"
wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/pkg.deb
sudo dpkg -i /tmp/pkg.deb
sudo apt-get update -q
sudo apt-get install -y dotnet-sdk-8.0

echo "==> Building backend"
cd /home/ubuntu/demo-app/backend
dotnet restore
dotnet publish -c Release -o /home/ubuntu/backend-publish

echo "==> Creating systemd service"
sudo bash -c 'cat > /etc/systemd/system/demoapp.service << EOF
[Unit]
Description=DemoApp .NET 8 Backend
After=network.target

[Service]
WorkingDirectory=/home/ubuntu/backend-publish
ExecStart=/usr/bin/dotnet /home/ubuntu/backend-publish/DemoApp.dll
Restart=always
RestartSec=10
SyslogIdentifier=demoapp
User=ubuntu
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://0.0.0.0:5000

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable demoapp
sudo systemctl start demoapp

echo "==> Backend running on port 5000"
sudo systemctl status demoapp --no-pager
