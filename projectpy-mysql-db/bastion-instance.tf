# Bastion Host
resource "aws_instance" "bastion" {
  ami           = var.app_ami
  instance_type = var.bastion_instance_type
  key_name      = aws_key_pair.dev_proj_1_public_key.key_name

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-bastion"
    Environment = var.environment
  }
}

resource "aws_eip" "bastion" {
  domain = "vpc"
  instance = aws_instance.bastion.id
  
  tags = {
    Name = "${var.project_name}-bastion-eip"
  }
}

resource "aws_key_pair" "dev_proj_1_public_key" {
  key_name   = "aws_key"
  public_key = file(var.public_key)
}