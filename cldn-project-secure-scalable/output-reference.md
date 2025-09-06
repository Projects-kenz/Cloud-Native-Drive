##  Multi-AZ AWS Architecture — Deployment Output

  
This diagram illustrates the final setup of a highly available, scalable infrastructure across `us-east-1a` and `us-east-1b`.  


  
<img width="1200" alt="Screenshot 2025-09-05 231723" src="https://github.com/user-attachments/assets/322d45e8-d813-4755-8575-e96455526f9b" />  
 
<img width="1200" alt="Screenshot 2025-09-05 231846" src="https://github.com/user-attachments/assets/d625da45-decd-4b2b-9f48-fe34cae073c4" />  

  
---


      
##  VPC & Subnet Layout — Multi-AZ Design

Includes public and private subnets across `us-east-1a` and `us-east-1b`, with CIDR blocks, route tables, and NACL associations.  
Designed for high availability, modular scaling, and least privilege access.  

  

<img width="1200" alt="Screenshot 2025-09-05 233221-VPC-flow" src="https://github.com/user-attachments/assets/fb7ead23-b96e-4f33-9fe1-4413f1688b22" />  

<img width="800" height="833" alt="Screenshot 2025-09-05 232936private-subnet-RT" src="https://github.com/user-attachments/assets/c3e7eccc-b107-47e8-bccf-6e60b45ba277" />  

<img width="800" height="832" alt="Screenshot 2025-09-05 233115public-subnet-RT" src="https://github.com/user-attachments/assets/0cad92fa-f632-4267-8c43-4daff32497d9" />  
 

  
---



    
##  Security Group Rules — Layered Access Control

<img width="1200" alt="Screenshot 2025-09-05 232401-all-sg-vpc" src="https://github.com/user-attachments/assets/77b2794c-cef2-4d5f-87d4-4d9fc38c21ee" />  

  

---

##  NAT Gateway Configuration — Public Connectivity for Private Subnets  


<img width="1000" alt="Screenshot 2025-09-05 233316NAT-list" src="https://github.com/user-attachments/assets/7f668bc6-6af3-45a7-bd36-54bdd53415c7" />   


  
---

  
##  Application Load Balancer — Listener & Target Group Setup  


Includes ALB listener rules, DNS endpoints, and target group health status.  
Demonstrates traffic routing across healthy EC2 instances in private subnets.  

  

### Listeners  
  
<img width="1000" alt="Screenshot 2025-09-05 233425LB-listeners" src="https://github.com/user-attachments/assets/ba3e83aa-bb98-4bd6-a018-94c958377798" />  
  

### Target Group  

<img width="1000" alt="Screenshot 2025-09-05 233518ALB-TG" src="https://github.com/user-attachments/assets/c371d7c0-be07-4bcf-9eb7-582b34ad4b9f" />  
  

### ALB-Resourcemap  
  
  
<img width="1000" alt="Screenshot 2025-09-05 233616ALB-Resourcemap" src="https://github.com/user-attachments/assets/197c2a52-ef10-42c3-aed9-3624f9433090" />  
  

  
  

---

##  Auto Scaling Group — Launch Template & Capacity Strategy

Covers launch template parameters, scaling limits, health checks, and subnet mappings.  
Designed for dynamic scaling and fault tolerance across `us-east-1a` and `us-east-1b`.  


### Launch Template  

<img width="1000" alt="Screenshot 2025-09-05 233904Launch-template" src="https://github.com/user-attachments/assets/02449136-b5e2-40ce-87e1-2080a1a84192" />   

### AutoScaling Group  

<img width="1000" alt="Screenshot 2025-09-05 234104autoscaling-p1" src="https://github.com/user-attachments/assets/a38a281b-c90f-4331-84f4-2ef3957e3163" />  

<img width="1000" alt="Screenshot 2025-09-05 234207autoscaling-part2" src="https://github.com/user-attachments/assets/a36d73ec-dd67-4a82-89d6-db66c50e13ed" />  

  
---

  
##  Network ACLs — Public & Private Subnet Rules

###  Inbound Public Subnet NACL  

<img width="600" src="https://github.com/user-attachments/assets/e9f5c644-17df-4596-972f-fad7ab316077" />  


###  Outbound Public Subnet NACL  

<img width="600" src="https://github.com/user-attachments/assets/74346ecd-335c-4ffa-b696-5dbeb489fb8f" />  


###  Inbound Private Subnet NACL  

<img width="600" src="https://github.com/user-attachments/assets/177bd56b-8b41-4567-93ae-970da686c230" />  


###  Outbound Private Subnet NACL  

<img width="600" src="https://github.com/user-attachments/assets/efe77984-4e65-495b-b56d-3b57a4c4f85c" />  

