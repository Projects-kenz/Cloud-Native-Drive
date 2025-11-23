# VPC Module [citation:9]
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  create_database_subnet_group = true

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}