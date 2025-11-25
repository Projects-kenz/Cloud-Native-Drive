#  AWS Multi-AZ VPC Architecture + Flask User Management System  
Below is the full multi-AZ Rough VPC architecture used in this project:  
![projectpy-mysql-diagram_page-0001 (1)](https://github.com/user-attachments/assets/f47ef637-ad9d-4748-a8f4-363eaba2086d)  
  
This project combines a **secure, multi-AZ AWS VPC architecture** with a **comprehensive Flask-based User Management System** running on EC2 servers.  

The Flask app includes: 

- User authentication (login/logout)  
- Role-based access control (admin/user)  
- Modern admin dashboard (Flask-Admin)  
- Full CRUD operations for users  
- REST API endpoint for user data (`/api/users`)  
- Health check endpoint (`/health`)
  
    > **Disclaimer / Note:**  
    > This Python Flask application is **GPT-generated** for exploring RDS MySQL and understanding a full-stack setup on AWS. In most of my projects, I typically use **container images** instead of AWS-native database services.  
    >
    > I have gone through the Flask program **briefly** but not thoroughly, and I **do not have prior experience with Apache**. The UserData script in Terraform initially failed, so I manually connected via SSH from the Bastion to one of the servers, pasted the installation and configuration commands line by line into Notepad, and ran them successfully with guidance from GPT.  
    >
    > For the second server, I converted this into a shell script (recorded from Notepad) and executed it successfully. Installing Apache and configuring it was done **entirely with GPT’s help**.  
    

The app runs on **Apache + mod_wsgi** inside private EC2 instances, connected to **RDS MySQL**.

---

# 🗺️ VPC Overview

This is a pattern I’ve built across different environments, refining it every time.  
Here, the design is clean and easy to troubleshoot to validate the full flow without distractions.  

I skipped ASG because even with fixed desired capacity, it can replace instances if health checks fail.  
Static EC2 servers make testing and debugging easier. ASG is perfect for production but not for initial validation.

All resources are provisioned using **Terraform**.

---  

## 🧩 What This Setup Includes

- VPC across **2 Availability Zones**  
- Public, private, and database subnets  
- Application Load Balancer (HTTPS with ACM)  
- EC2 App Servers running **Python Flask + Apache** in private subnets  
- RDS MySQL in fully isolated DB subnets  
- NAT Gateways in both AZs  
- Bastion Host for secure SSH access  
- Route53 for DNS + SSL validation  

Everything is placed in clear layers so the environment stays organized and secure.

---

# 📚 Architecture Layers

## 1. Public Subnets (AZ-1 & AZ-2)

### AZ-1 Public Subnet Contains
- Application Load Balancer (ALB)  
- Bastion Host  
- NAT Gateway  

### AZ-2 Public Subnet Contains
- ALB node (multi-AZ)  
- NAT Gateway  

The ALB handles all incoming user traffic. The Bastion and NAT Gateways support secure admin(me) access and outbound traffic respectively.

---

## 2. Private App Subnets (AZ-1 & AZ-2)

### Contains
- EC2 App Server 1 (Flask + Apache)  
- EC2 App Server 2 (Flask + Apache)  

**Access:**
- Users → ALB → App Servers  
- Admin(me) → Bastion → App Servers  

 Run the Flask User Management System Application in private, isolated subnets, and each AZ has its own App Server for high availability.

---

## 3. Database Subnets (AZ-1 & AZ-2)

### Contains
- RDS MySQL (Primary)  

**Access:**
- App Servers  
- Bastion (SSH tunnel for MySQL Workbench)  

**Purpose:** Secure storage for the Flask app data.

---

# 🔄 Traffic Flow

## **A. User Traffic (Browser → ALB → App → DB)**

1. User opens the domain in browser.  
2. Route53 resolves domain → ALB.  
3. ALB handles HTTPS via ACM certificate.  
4. The ALB forwards the request to the target group, which includes both app servers:
   - App Server 1 (AZ-1)  
   - App Server 2 (AZ-2)  
5. Load balancing selects server based on health.  
6. Flask app processes request → communicates with RDS.  
7. Response flows back: **App → ALB → User**

---

## **B. Admin(me) Access (My PC → Bastion → App/DB)**

1. I connect to the Bastion over SSH from my PC.  
2. The Bastion is the only admin entry point into the VPC.  
3. From the Bastion:
     - I can SSH into App Server 1
     - I can SSH into App Server 2
4. For database access:
     - My PC → Bastion (SSH Tunnel) → RDS
     - Or Bastion → RDS directly within the VPC

---

## **C. Outbound Traffic From Private App Servers**

1. App Server 1 uses the NAT Gateway in **AZ-1**.
2. App Server 2 uses the NAT Gateway in **AZ-2**.
3. Each NAT Gateway sends traffic out to the Internet for:
     - OS updates
     - Package installations
     - External API calls

 
 Outbound traffic stays within each AZ (no cross-AZ charges).



---

# 💻 Flask User Management App Features

- Authentication (login/logout)  
- Role-based access control (admin/user)  
- Admin dashboard using **Flask-Admin**  
- CRUD operations for user management  
- REST API `/api/users`  
- Health check endpoint `/health`  
- Passwords hashed securely  

**Tech Stack:**

- Python Flask  
- SQLAlchemy ORM  
- Flask-Login  
- Flask-Admin  
- Apache + mod_wsgi  
- MySQL (RDS)

---

# 🔧 Provisioning & Deployment

- Terraform provisions: VPC, subnets, routing, security groups, ALB, NAT, EC2, RDS, Route53  
- Flask app deployed on **EC2 with Apache + mod_wsgi**  
- MySQL database accessible only from private app servers or Bastion  
- Secure network design with private/public separation  

---

**Kenz Muhammed C K**  
📧 kenzmuhammedc@gmail.com  
💼 Finding balance between clean infrastructure, useful automation, and real-world simplicity.
