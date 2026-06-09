
resource "aws_security_group" "alb-sg" {
    name = "alb-sg"
    description = "Security group for ALB"
    vpc_id = aws_vpc.cldsec-vpc.id
    
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
         protocol = "tcp"
         from_port = 443
         to_port = 443
         cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "tcp"
        from_port = 0
        to_port = 65535
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_lb" "web-alb" {
    name = "${var.projectname}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb-sg.id]
    subnets = [aws_subnet.pub-subnet1.id, aws_subnet.pub-subnet2.id]
}

resource "aws_lb_target_group" "web-tg" {
    name = "${var.projectname}-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.cldsec-vpc.id
    health_check {
        path = "/"
        protocol = "HTTP"
        interval = 30
        timeout = 5
        healthy_threshold = 5
        unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group_attachment" "web-tg-attachment1" {
    target_group_arn = aws_lb_target_group.web-tg.arn
    target_id = aws_instance.web-server1.id
    port = 80
}
resource "aws_lb_target_group_attachment" "web-tg-attachment2" {
    target_group_arn = aws_lb_target_group.web-tg.arn
    target_id = aws_instance.web-server2.id
    port = 80
}

resource "aws_lb_listener" "web-alb-listener" {
    load_balancer_arn = aws_lb.web-alb.arn
    port = 80
    protocol = "HTTP"
    
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web-tg.arn
    }
}
resource "aws_lb_listener" "web-alb-listener-https" {
    load_balancer_arn = aws_lb.web-alb.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
    certificate_arn = var.certificate_arn
    
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web-tg.arn
    }
}