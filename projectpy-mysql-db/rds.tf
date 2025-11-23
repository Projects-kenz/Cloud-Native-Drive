# RDS Database
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = module.vpc.database_subnets

  tags = {
    Name = "${var.project_name}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type           = "gp2"
  
  db_name                = var.database_name
  username               = var.db_username
  password               = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  skip_final_snapshot    = true
  multi_az               = false
  backup_retention_period = 1
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
