# EC2 Instances
resource "aws_instance" "app" {
  count = var.app_instance_count

  ami           = var.app_ami
  instance_type = var.app_instance_type
  key_name      = aws_key_pair.dev_proj_1_public_key.key_name

  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  
  associate_public_ip_address = false

  user_data = filebase64(var.user_data_script)

  tags = {
    Name = "${var.project_name}-app-${count.index + 1}"
    Environment = var.environment
  }
}

