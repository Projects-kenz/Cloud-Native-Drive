#!/bin/bash
# User Data Script - DevOps Portfolio Website

# Update system
apt-get update -y

# Install Apache
apt-get install -y apache2

# Start Apache
systemctl start apache2
systemctl enable apache2

# Create portfolio page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kenz's DevOps Portfolio</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f4f4f9; color: #333; margin: 0; padding: 0; }
    header { background: #2c3e50; color: #fff; padding: 20px; text-align: center; }
    h1 { margin: 0; }
    .container { max-width: 900px; margin: 30px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    ul { list-style: none; padding: 0; }
    li { background: #ecf0f1; margin: 10px 0; padding: 12px; border-radius: 6px; font-size: 18px; }
    footer { text-align: center; padding: 15px; background: #2c3e50; color: #fff; margin-top: 30px; }
  </style>
</head>
<body>
  <header>
    <h1>**Kenz Muhammed** C K</h1>
    <p>DevOps & Cloud Portfolio2</p>
  </header>

  <div class="container">
    <h2>Important Tools Covered</h2>
    <ul>
      <li>Linux & Bash Scripting</li>
      <li>Git & GitHub</li>
      <li>AWS (EC2, VPC, S3, IAM, Load Balancers, Security Groups, Route Tables, etc.)</li>
      <li>Terraform</li>
      <li>Ansible</li>
      <li>Jenkins</li>
      <li>Docker</li>
      <li>Kubernetes (EKS, Ingress, RBAC, etc.)</li>
      <li>Monitoring & Logging Basics</li>
    </ul>
  </div>

  <footer>
    <p>© 2025 **Kenz Muhammed** C K | DevOps Enthusiast</p>
  </footer>
</body>
</html>
EOF
