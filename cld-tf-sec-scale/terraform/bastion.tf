resource "aws_security_group" "Bastion-sg" {
    name = "bastion-sg"
    description = "Security group for bastion"
    vpc_id = aws_vpc.cldsec-vpc.id
    
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "tcp"
        from_port = 0
        to_port = 65535
        cidr_blocks = ["0.0.0.0/0"]
    }
}



resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}



resource "aws_instance" "bastion-host" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.pub-subnet1.id
    security_groups = [aws_security_group.Bastion-sg.id]
    key_name = aws_key_pair.bastion_key.key_name
    associate_public_ip_address = true
     
    tags = {
        Name = "${var.projectname}-bastion-host"
    }
}