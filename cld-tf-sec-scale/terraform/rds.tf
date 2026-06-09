resource "aws_db_subnet_group" "db-sbnet-group" {
   subnet_ids = [ aws_subnet.db-subnet1.id, aws_subnet.db-subnet2.id ]
    name = "db-subnet-group"
}
resource "aws_db_parameter_group" "db-parameter-group" {
    family = var.db-parameter-group-family
    name = var.db-parameter-group-name
    parameter {
    name  = "log_connections" #log connections to the database
    value = "all"
  }
    parameter {
        name  = "log_disconnections" #log disconnections from the database
        value = "1"
    }
    
    parameter {
    name  = "timezone" #timezone for the database
    value = "UTC"
  }
   
  parameter {
    name  = "idle_in_transaction_session_timeout" #Kill transactions that were started but abandoned.
    value = "600000"
  }
   parameter {
    name         = "max_connections" #maximum number of concurrent connections to the database
    value        = "200"
    apply_method = "pending-reboot"
  }
  parameter {
        name  = "log_statement" #log slow queries and all queries that take longer than 1000ms to execute
        value = "all"
    }
   parameter {
    name         = "log_min_duration_statement" #it will log all statements that take longer than 1000ms to execute
    value        = "1000"
    apply_method = "pending-reboot"
   }
   parameter { 
    name         = "statement_timeout"  #maximum time a query is allowed to run
    value        = "300000"
   }
   
}

resource "aws_db_instance" "cldsec-db-instance" {
  identifier = var.db-identifier
  allocated_storage = var.db-allocated-storage
  engine = var.db-engine
  #engine_version = var.db-engine-version
  instance_class = var.db-instance-class
  max_allocated_storage = var.db-maxallocated-storage
  storage_type = var.db-storage-type
  #iops = var.db-iops
  #storage_encrypted = true
  #kms_key_id = aws_kms_key.cldsec-kms.arn
  multi_az = false
  backup_retention_period = 0
  #preferred_backup_window = var.preferred_backup_window
  #preferred_maintenance_window = var.preferred_maintenance_window
  auto_minor_version_upgrade = true
  deletion_protection = false
  skip_final_snapshot = true
  #final_snapshot_identifier = 
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.db-sbnet-group.name
  parameter_group_name = aws_db_parameter_group.db-parameter-group.name
  username = var.db-username
  password = var.db-password
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  monitoring_interval = 0
  #performance_insights_enabled = true
  #performance_insights_retention_period = 7

}

data "aws_caller_identity" "current" {}
resource "aws_kms_key" "cldsec-kms" {
   description = "KMS key for encrypting RDS database"
   enable_key_rotation = true
    deletion_window_in_days = 7
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # AWS mandatory: account retains full control of the key
        Sid    = "EnableRootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = ["kms:*"]
        Resource = "*"
      },
      {
      Sid    = "AllowTerraformUser"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Kenz-Tf"
      }
      Action = ["kms:*"]
      Resource = "*"
    }
    ]
  })
    multi_region = false
    key_usage = "ENCRYPT_DECRYPT"
    tags = {
        Name = "${var.projectname}-kms-key"
    }
}
resource "aws_kms_alias" "cldsec-kms-alias" {
    name = "alias/${var.projectname}-kms-alias"
    target_key_id = aws_kms_key.cldsec-kms.key_id

}

resource "aws_security_group" "rds-sg" {
    name = "rds-sg"
    description = "Security group for RDS"
    vpc_id = aws_vpc.cldsec-vpc.id
    
    ingress {
        protocol = "tcp"
        from_port = 5432
        to_port = 5432
        cidr_blocks = [var.priv-subnet1_cidr, var.priv-subnet2_cidr]
    }
    egress {
        protocol = "tcp"
        from_port = 0
        to_port = 65535
        cidr_blocks = [var.priv-subnet1_cidr, var.priv-subnet2_cidr]
    }
}































# resource "aws_iam_role" "rds-iam-role" {
#     name = "${var.projectname}-rds-iam-role"
#     assume_role_policy = jsonencode({
#         Version = "2012-10-17",
#         Statement = [
#             {
#                 Effect = "Allow",
#                 Principal = {
#                     Service = "rds.amazonaws.com"
#                 },
#                 Action = "sts:AssumeRole"
#             }
#         ]
#     })
# }

# resource "aws_iam_policy" "rds-iam-policy" {
#     name = "${var.projectname}-rds-iam-policy"
#     description = "IAM policy for RDS to access CloudWatch Logs and KMS"
#     policy = jsonencode({
#         Version = "2012-10-17",
#         Statement = [
#             {
#                 Effect = "Allow",
#                 Action = [
#                     "logs:CreateLogGroup",
#                     "logs:CreateLogStream",
#                     "logs:PutLogEvents"
#                 ],
#                 Resource = "arn:aws:logs:*:*:*"
#             },
#             {
#                 Effect = "Allow",
#                 Action = [
#                     "kms:Encrypt",
#                     "kms:Decrypt",
#                     "kms:GenerateDataKey",
#                     "kms:DescribeKey"
#                 ],
#                 Resource = aws_kms_key.cldsec-kms.arn
#             }
#         ]
#     })
# }
# resource "aws_iam_role_policy_attachment" "rds-iam-role-attachment" {
#     role = aws_iam_role.rds-iam-role.name
#     policy_arn = aws_iam_policy.rds-iam-policy.arn
  
# }

# resource "aws_db_instance_role_association" "rds-role-attach" {
#   db_instance_identifier = aws_db_instance.cldsec-db.identifier
#   feature_name           = "S3_INTEGRATION"
#   role_arn               = aws_iam_role.rds-iam-role.arn
# }