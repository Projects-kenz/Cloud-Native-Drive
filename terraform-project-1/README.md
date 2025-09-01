<img width="1536" height="1024" alt="ec7deac0-803b-4573-be9e-60340eaaca7a" src="https://github.com/user-attachments/assets/38d9bf74-3a1a-4725-b0c0-6d7cff3f3b0e" />

  

# 🌍 AWS Infrastructure with Terraform

This project demonstrates how to use **Terraform** to provision a simple but complete AWS infrastructure.  
It sets up a **VPC, subnets, EC2 instances, Application Load Balancer, and an S3 bucket** — all automated through code.

---

## 🏗️ What This Project Does

- Creates a **VPC** (`10.0.0.0/16`)  
- Adds **two public subnets** in different Availability Zones (`10.0.1.0/24`, `10.0.2.0/24`)  
- Attaches an **Internet Gateway** and public **Route Table**  
- Launches **two EC2 instances** in the subnets (with user_data scripts to install web servers)  
- Creates an **Application Load Balancer (ALB)** that balances traffic across the two instances  
- Sets up an **S3 bucket** for logs or static storage  
- Outputs the **ALB DNS name** at the end for quick testing


## Important Notes

**Security Groups**
For simplicity, this demo uses the same Security Group for both EC2 and the ALB.
This works, but in real-world scenarios you should separate them (for security):

ALB SG → allow inbound traffic from 0.0.0.0/0 (ports 80/443).

EC2 SG → allow inbound only from the ALB SG.

That way, your EC2 instances aren’t directly exposed to the internet.
