#vpc
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc-cidr_block
}

#igw for vpc
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
}

#public subnet 1
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.sub1-cidr_block
  map_public_ip_on_launch=true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public1"
  }
}

#public subnet 2
resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.sub2-cidr_block
  map_public_ip_on_launch= true
  availability_zone = "us-east-1b"
  tags = {
    Name = "public2"
  }
}

#route table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }


  tags = {
    Name = "RT-igw"
  }
}

#Route table Association 1

resource "aws_route_table_association" "RT-a" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

#Route table Association 1

resource "aws_route_table_association" "RT-b" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

#s3
resource "aws_s3_bucket" "my-bucket" {
  bucket = "tf-project1-bucket-kenz"

  tags = {
    Name        = "bucket-logs"
    Environment = "Dev"
  }
}

# security group ec2
resource "aws_security_group" "sg-ec2" {
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#instance1
resource "aws_instance" "webserver1" {
  ami           = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  key_name = "server"
  subnet_id = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]
  user_data_base64 = base64encode(file("demo-userdata.sh"))
 
  tags = {
    Name = "instance-1"
  }
}

#instance2
resource "aws_instance" "webserver2" {
  ami           = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  key_name = "server"
  subnet_id = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]
  user_data_base64 = base64encode(file("demo-userdata2.sh"))
  

  tags = {
    Name = "instance-2"
  }
}

#alb
resource "aws_lb" "my-alb" {
  name               = "tf-project-my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-ec2.id]
  subnets            = [aws_subnet.sub1.id,aws_subnet.sub2.id]
}

#alb target group
resource "aws_lb_target_group" "my-alb-tg" {
  name        = "tf-project-my-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my-vpc.id
  health_check {
    path = "/"                         
    port = "traffic-port"
  }
}

#alb target group attachment for webserver1
resource "aws_lb_target_group_attachment" "my-alb-tg-attach1" {
  target_group_arn = aws_lb_target_group.my-alb-tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
} 

#alb target group attachment for webserver2
resource "aws_lb_target_group_attachment" "my-alb-tg-attach2" {
  target_group_arn = aws_lb_target_group.my-alb-tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
} 

#alb listener
resource "aws_lb_listener" "my-alb-listener" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "80"
  protocol          = "HTTP"
 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-alb-tg.arn
  }
}

output "loadbalancerdns" {
  value = aws_lb.my-alb.dns_name
}
