output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}


output "app_instance_private_ips" {
  description = "Private IP addresses of application instances"
  value       = aws_instance.app[*].private_ip
}

output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = aws_eip.bastion.public_ip
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

