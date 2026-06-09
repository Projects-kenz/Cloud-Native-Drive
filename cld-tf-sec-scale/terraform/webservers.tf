
#private key same as bastion key
resource "aws_security_group" "web-sg" {
    name = "web-sg1"
    description = "Security group for web servers"
    vpc_id = aws_vpc.cldsec-vpc.id
    
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = [var.pub-subnet1_cidr, var.pub-subnet2_cidr]
    }       
    egress {
        protocol = "tcp"
        from_port = 0
        to_port = 65535
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web-server1" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.priv-subnet1.id
    security_groups = [aws_security_group.web-sg.id]
    key_name = aws_key_pair.bastion_key.key_name
    tags = {
        Name = "${var.projectname}-web-server1"
    }
}   
resource "aws_instance" "web-server2" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.priv-subnet2.id
    security_groups = [aws_security_group.web-sg.id]
    key_name = aws_key_pair.bastion_key.key_name
    tags = {
        Name = "${var.projectname}-web-server2"
    }
}