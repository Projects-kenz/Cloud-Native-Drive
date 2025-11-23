variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "kenzopsify"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

# Subnet CIDRs
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.100.0/24", "10.0.200.0/24"]
}

# EC2 Variables


variable "app_instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t3.micro"
}

variable "app_ami" {
  description = "AMI ID for application instances"
  type        = string
  default     = "ami-0f5fcdfbd140e4ab7" # Amazon Linux 2
}

variable "app_instance_count" {
  description = "Number of application instances"
  type        = number
  default     = 2
}

variable "app_port" {
  description = "Application port number"
  type        = number
  default     = 5000
}

# Bastion Variables
variable "bastion_instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# RDS Variables
variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "kenzopsify"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

# Domain & DNS Variables
variable "domain_name" {
  description = "Primary domain name"
  type        = string
  default     = "kenzopsify.site"
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

# User Data
variable "user_data_script" {
  description = "Path to user data script"
  type        = string
  default     = "./scripts/userdata-app-instance.sh"
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
  default="./scripts/id_ed25519.pub"
}
