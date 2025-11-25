# Deploying a Secure & Scalable VPC Architecture for Web Application 
<img width="856" height="675" alt="image" src="https://github.com/user-attachments/assets/b81e73a3-aa20-4bba-b009-2987b5d7bffd" />


## What this project is about  
I built a small but production-like setup on AWS where:  
- I have **private EC2 instances (Managed by an Auto Scaling Group)** (so they’re not directly exposed to the internet).  
- Those instances run a **Flask app on port 8080**.  
- A **Load Balancer** listens on port 80 and forwards traffic to those instances.  
- A **Bastion host** in the public subnet is my way in (for SSH access).  
- A **NAT Gateway** makes sure the private servers can still install packages (like Python modules with pip3).  
- Everything is wrapped inside an **Auto Scaling Group** (min=1, desired=2, max=3 instances).  
  
So, users hit the ALB → requests go to one of the private EC2s → app responds.  
Admins (me) go in via the Bastion host if I need to debug or install something.  
  
---  
  
## How it’s set up  
  
- **Bastion Host**  
  - Public subnet, Elastic IP.  
  - I SSH into this box first, then jump into private instances.  
  - Security group only allows port 22 from *my IP*.  
  
- **Private Instances (Auto Scaling Group)**  
  - t2.micro EC2s spread across two AZs.  
  - Run Flask on port 8080.  
  - Security group only allows port 8080 from the Load Balancer.  
  - Auto Scaling keeps 2 running by default, but can shrink to 1 or grow to 3.  
  
- **NAT Gateway**  
  - Sits in the public subnet.  
  - Lets private servers `yum install` or `pip3 install` without giving them public IPs.  
  
- **Load Balancer**  
  - Listener on port 80.  
  - Target group forwards to private EC2s on port 8080.  
  - Does health checks to only send traffic to healthy servers.  
  
---  
  
## 1️⃣ Public Subnet NACL (Inbound Rules)  
  
| Rule # | Port/Type        | Source           | Allow/Deny | Purpose (Project-Specific) |  
|--------|-----------------|-----------------|------------|----------------------------|  
| 100    | TCP 80 (HTTP)    | 0.0.0.0/0       | ALLOW      | Allow users to send HTTP requests to ALB |  
| 105    | TCP 443 (HTTPS)  | 0.0.0.0/0       | ALLOW      | Allow users to send HTTPS requests to ALB |  
| 110    | TCP 22 (SSH)     | YourAdminIP/32  | ALLOW      | Allow admin to SSH into Bastion host only |  
| 115    | TCP 1024-65535   | 0.0.0.0/0       | ALLOW      | Allow return traffic from NAT/Bastion initiated connections (ephemeral ports) |  
| *      | ALL              | 0.0.0.0/0       | DENY       | Block all other inbound traffic |  

  
---  


  **Public Subnet NACL (Outbound Rules)**  
    
| Rule # | Port/Type        | Destination      | Allow/Deny | Purpose (Project-Specific) |  
|--------|-----------------|-----------------|------------|----------------------------|  
| 103    | TCP 80 (HTTP)    | 0.0.0.0/0       | ALLOW      | NAT Gateway / Bastion HTTP requests to Internet |  
| 104    | TCP 443 (HTTPS)  | 0.0.0.0/0       | ALLOW      | NAT Gateway / Bastion HTTPS requests to Internet |  
| *      | ALL              | 0.0.0.0/0       | DENY       | Block all other outbound traffic |  
  


---  

**Private Subnet NACL (Inbound Rules)**
  
| Rule # | Port/Type       | Source           | Allow/Deny | Purpose (Project-Specific) |  
|--------|----------------|-----------------|------------|----------------------------|  
| 100    | TCP 8080       | 13.0.0.0/20     | ALLOW      | Allow ALB in AZ1 to reach Flask app |  
| 101    | TCP 8080       | 13.0.16.0/20    | ALLOW      | Allow ALB in AZ2 to reach Flask app |  
| 102    | TCP 22 (SSH)   | 13.0.0.0/20     | ALLOW      | Allow Bastion in AZ1 to SSH private EC2s |  
| 103    | TCP 22 (SSH)   | 13.0.16.0/20    | ALLOW      | Allow Bastion in AZ2 to SSH private EC2s |  
| 106    | TCP 1024-65535 | 0.0.0.0/0       | ALLOW      | Allow ephemeral return traffic from NAT/Bastion (responses back to private EC2s) |  
| *      | ALL            | 0.0.0.0/0       | DENY       | Block all other inbound traffic |  
  
---  

**4️⃣ Private Subnet NACL (Outbound Rules)**  
  
| Rule # | Port/Type       | Destination     | Allow/Deny | Purpose (Project-Specific) |  
|--------|----------------|----------------|------------|----------------------------|  
| 100    | TCP 80 (HTTP)   | 0.0.0.0/0      | ALLOW      | Private EC2s download packages via NAT Gateway |  
| 101    | TCP 443 (HTTPS) | 0.0.0.0/0      | ALLOW      | Private EC2s securely download packages via NAT Gateway |  
| 102    | TCP 1024-65535  | 0.0.0.0/0      | ALLOW      | Return traffic to private EC2s from NAT (responses from ephemeral source ports) |  
| *      | ALL             | 0.0.0.0/0      | DENY       | Block all other outbound traffic |  

  

---  


## How to connect

- **Step 1: Copy your PEM file (if needed)**
  If you need your `.pem` file inside the Bastion host to jump into private instances:
  ```bash
  scp -i <your-key.pem> <your-key.pem> ubuntu@<Bastion_EIP>:/home/ubuntu/

- **Step 2: SSH into Bastion Host**  
  
  ssh -i your-key.pem ubuntu@<Bastion_EIP>


- **Step 3: From Bastion → SSH into Private EC2 (managed by Auto Scaling Group)**  
  
  ssh -i your-key.pem ubuntu@<Private_EC2_IP>
