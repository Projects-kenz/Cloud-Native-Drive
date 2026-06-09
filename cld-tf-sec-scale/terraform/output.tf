output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion-host.public_ip
}
output "ssh-private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
output "web_server1_private_ip" {
  description = "Private IP address of web server 1"
  value       = aws_instance.web-server1.private_ip
}
output "web_server2_private_ip" {
  description = "Private IP address of web server 2"
  value       = aws_instance.web-server2.private_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.cldsec-db-instance.endpoint
}
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.web-alb.dns_name
}
