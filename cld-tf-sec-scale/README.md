# Secure & Scalable Web App on AWS — .NET 8 + Angular + PostgreSQL

A full-stack app (Angular frontend, .NET 8 Web API, PostgreSQL on RDS) deployed on a 3-tier AWS network — public/private/database subnets, load-balanced EC2 instances, bastion-only SSH access, and HTTPS via a custom domain. All infrastructure is provisioned with Terraform.

## Stack

| Layer | Tech |
|---|---|
| Frontend | Angular 17 (production build) |
| Backend | .NET 8 Web API + EF Core |
| Database | PostgreSQL 18 on Amazon RDS |
| Reverse proxy | Nginx |
| Load balancer | AWS ALB |
| DNS / TLS | Route 53 + ACM |
| IaC | Terraform |
| Compute | EC2 t3.micro |

## Architecture

```
Internet
   │
   ▼
Route 53 — cldsec-tf.kenzopsify.site
   │
   ▼
ALB (public subnets, HTTPS via ACM) ──┬─────────────┐
                                       ▼             ▼
                              EC2 web-server1   EC2 web-server2
                              (private, AZ-a)   (private, AZ-b)
                              Nginx → Angular   Nginx → Angular
                              Nginx → .NET API  Nginx → .NET API
                                       │             │
                                       └──────┬──────┘
                                              ▼
                                    RDS PostgreSQL
                                    (isolated DB subnets)

Bastion (public subnet) → SSH → web-server1 / web-server2
NAT gateways (public subnets) → outbound internet for private subnets
```

| Layer | Subnets | CIDR |
|---|---|---|
| Public | pub-subnet1 (us-east-2a), pub-subnet2 (us-east-2b) | 10.0.1.0/24, 10.0.2.0/24 |
| Private (app) | priv-subnet1 (us-east-2a), priv-subnet2 (us-east-2b) | 10.0.3.0/24, 10.0.4.0/24 |
| Database | db-subnet1 (us-east-2a), db-subnet2 (us-east-2b) | 10.0.5.0/24, 10.0.6.0/24 |

VPC: `10.0.0.0/16`

## Infrastructure (Terraform)

<details>
<summary>VPC & Subnets</summary>

![VPC](images/08-vpc.jpg)
![Subnets](images/09-subnets.jpg)

</details>

<details>
<summary>Route Tables</summary>

![Route Tables](images/10-route-tables.jpg)

Public → IGW:
![Public Route Table](images/11-public-route-table.jpg)

Private (app) → NAT Gateway:
![Private Route Table](images/12-private-route-table.jpg)

Database → local only, no internet route:
![DB Route Table](images/13-db-route-table.jpg)

</details>

<details>
<summary>Internet & NAT Gateways</summary>

![Internet Gateway](images/14-internet-gateway.jpg)
![NAT Gateways](images/15-nat-gateways.jpg)
![Elastic IPs](images/16-elastic-ips.jpg)

</details>

<details>
<summary>Security Groups & NACLs</summary>

| SG | Attached to | Allows |
|---|---|---|
| alb-sg | ALB | 80/443 from internet |
| web-sg1 | App servers | 80 from ALB, 22 from public subnets |
| bastion-sg | Bastion | 22 from internet |
| rds-sg | RDS | 5432 from app subnets only |

![Security Groups](images/07-security-groups.jpg)
![Network ACLs](images/17-network-acls.jpg)

</details>

<details>
<summary>EC2 Instances</summary>

bastion-host (public), web-server1 (private AZ-a), web-server2 (private AZ-b) — same key pair, all passing status checks.

![EC2 Instances](images/06-ec2-instances.jpg)

</details>

<details>
<summary>ALB & Target Group</summary>

![Load Balancer](images/03-load-balancer-overview.jpg)
![ALB Listeners](images/04-alb-listeners.jpg)
![Target Group Health](images/05-target-group-health.jpg)

</details>

<details>
<summary>Domain & TLS (Route 53 + ACM)</summary>

`cldsec-tf.kenzopsify.site` → CNAME → ALB. ACM certificate issued and bound to the HTTPS:443 listener (`ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09`).

![Route 53](images/01-route53-hosted-zone.jpg)
![ACM Certificate](images/02-acm-certificate.jpg)

</details>

## Deployment

- Nginx serves the Angular build from `/var/www/html`, with `try_files $uri $uri/ /index.html` for SPA routing.
- `/api/` requests are proxied to the .NET 8 API running on `localhost:5000` via systemd — never exposed directly.
- .NET connects to RDS PostgreSQL over EF Core with SSL enforced.
- Angular's `environment.production.ts` points at `https://cldsec-tf.kenzopsify.site/api` — same origin as the frontend, so no CORS issues.

## Load balancing

Both web servers are registered in the same target group and serve identical content. The ALB distributes traffic across both AZs and stops routing to either instance if its health check fails.

## Demo

![Product Inventory](images/18-product-inventory.jpg)
![Add Product](images/19-add-product-form.jpg)
![Edit Product](images/20-edit-product-form.jpg)
![Updated Inventory](images/21-product-inventory-final.jpg)

## Security

- App servers and RDS have no public IPs — only reachable from inside the VPC.
- Only the ALB (80/443) and bastion (22) are reachable from the internet.
- RDS only accepts connections from the app subnets on 5432.
- NACLs add a stateless layer on top of security groups.
- All public traffic is HTTPS via ACM.

## Next steps

- Auto Scaling Group instead of fixed instances
- Multi-AZ RDS
- CI/CD pipeline for deploys
- CloudWatch monitoring/alarms

