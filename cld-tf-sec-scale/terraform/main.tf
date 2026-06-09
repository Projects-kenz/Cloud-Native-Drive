resource "aws_vpc" "cldsec-vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "${var.projectname}-vpc"
    }
}       

resource "aws_subnet" "pub-subnet1" {
  vpc_id            = aws_vpc.cldsec-vpc.id
  cidr_block        = var.pub-subnet1_cidr
  availability_zone = "us-east-2a"
  tags = {
        Name = "${var.projectname}-pub-subnet1"
    }
}

resource "aws_subnet" "pub-subnet2" {
  vpc_id            = aws_vpc.cldsec-vpc.id
  cidr_block        = var.pub-subnet2_cidr
  availability_zone = "us-east-2b"
    tags = {
            Name = "${var.projectname}-pub-subnet2"
        }
}


resource "aws_internet_gateway" "cldsec-igw" {
  vpc_id = aws_vpc.cldsec-vpc.id
  tags = {
        Name = "${var.projectname}-igw"
    }
  
}

resource "aws_eip" "nat-eip1" {
   domain = "vpc" 
   tags = {
        Name = "${var.projectname}-nat-eip1"
    }
}

resource "aws_eip" "nat-eip2" {
   domain = "vpc" 
   tags = {
        Name = "${var.projectname}-nat-eip2"
    }
}

resource "aws_nat_gateway" "cldsec-natgw1" {
  allocation_id = aws_eip.nat-eip1.id
  subnet_id     = aws_subnet.pub-subnet1.id
  depends_on = [aws_eip.nat-eip1]
  tags = {
        Name = "${var.projectname}-natgw1"
    }
}

resource "aws_nat_gateway" "cldsec-natgw2" {
  allocation_id = aws_eip.nat-eip2.id
  subnet_id     = aws_subnet.pub-subnet2.id
  depends_on = [aws_eip.nat-eip2]
  tags = {
        Name = "${var.projectname}-natgw2"
    }
}

resource "aws_route_table" "cldsec-pub-rt" {
    vpc_id = aws_vpc.cldsec-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cldsec-igw.id
    }
    tags = {
        Name = "${var.projectname}-pub-rt"
    }
}

resource "aws_route_table_association" "cldsec-pub-rt-assoc1" {
    subnet_id = aws_subnet.pub-subnet1.id
    route_table_id = aws_route_table.cldsec-pub-rt.id
    
}
resource "aws_route_table_association" "cldsec-pub-rt-assoc2" {
    subnet_id = aws_subnet.pub-subnet2.id
    route_table_id = aws_route_table.cldsec-pub-rt.id
  
}



resource "aws_subnet" "priv-subnet1" {
  vpc_id            = aws_vpc.cldsec-vpc.id
  cidr_block        = var.priv-subnet1_cidr
  availability_zone = "us-east-2a"
    tags = {
            Name = "${var.projectname}-priv-subnet1"
        }
}

resource "aws_subnet" "priv-subnet2" {
  vpc_id            = aws_vpc.cldsec-vpc.id
  cidr_block        = var.priv-subnet2_cidr
  availability_zone = "us-east-2b"
    tags = {
            Name = "${var.projectname}-priv-subnet2"
        }
}



resource "aws_route_table" "cldsec-priv-rt1" {
    vpc_id = aws_vpc.cldsec-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.cldsec-natgw1.id
    }
    tags = {
        Name = "${var.projectname}-priv-rt1"
    }
}
resource "aws_route_table" "cldsec-priv-rt2" {
    vpc_id = aws_vpc.cldsec-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.cldsec-natgw2.id
    }
    tags = {
        Name = "${var.projectname}-priv-rt2"
    }
}

resource "aws_route_table_association" "cldsec-priv-rt-assoc1" {
    subnet_id = aws_subnet.priv-subnet1.id
    route_table_id = aws_route_table.cldsec-priv-rt1.id
   
}

resource "aws_route_table_association" "cldsec-priv-rt-assoc2" {
    subnet_id = aws_subnet.priv-subnet2.id
    route_table_id = aws_route_table.cldsec-priv-rt2.id
  
}


resource "aws_network_acl" "nacl-pub" {
    vpc_id = aws_vpc.cldsec-vpc.id
    subnet_ids = [aws_subnet.pub-subnet1.id, aws_subnet.pub-subnet2.id]
    
    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = "0.0.0.0/0"
    }
    ingress  {
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        from_port = 80
        to_port = 80
        cidr_block = "0.0.0.0/0"
    }
    ingress {
        protocol = "tcp"
        rule_no = 115
        action = "allow"
        from_port = 443
        to_port = 443
        cidr_block = "0.0.0.0/0"
    }
    ingress{
        protocol = "tcp"
        rule_no = 120
        action = "allow"
        from_port = 1024
        to_port = 65535
        cidr_block = "0.0.0.0/0"  
    }
    egress{
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = var.priv-subnet1_cidr

    }
    egress {
        protocol = "tcp"
        rule_no = 105
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = var.priv-subnet2_cidr
    }    
    egress {
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        from_port = 1024
        to_port = 65535
        cidr_block = "0.0.0.0/0"
    }
    egress {
        protocol = "tcp"
        rule_no = 115
        action = "allow"
        from_port = 443
        to_port = 443
        cidr_block = "0.0.0.0/0"
    }
    
    egress{
        protocol = "tcp"
        rule_no = 120
        action = "allow"
        from_port = 80
        to_port = 80
        cidr_block = "0.0.0.0/0"
    }
    tags = {
        Name = "${var.projectname}-nacl-pub"
    }
}


resource "aws_network_acl_association" "nacl-pub-assoc1" {
    network_acl_id = aws_network_acl.nacl-pub.id
    subnet_id = aws_subnet.pub-subnet1.id
}

resource "aws_network_acl_association" "nacl-pub-assoc2" {
    network_acl_id = aws_network_acl.nacl-pub.id
    subnet_id = aws_subnet.pub-subnet2.id
}



resource "aws_network_acl" "nacl-priv" {
    vpc_id = aws_vpc.cldsec-vpc.id
    subnet_ids = [aws_subnet.priv-subnet1.id, aws_subnet.priv-subnet2.id]
    
    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = var.pub-subnet1_cidr
    }
    ingress  {
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        from_port = 80
        to_port = 80
        cidr_block = var.pub-subnet1_cidr
    }
    ingress{
        protocol = "tcp"
        rule_no = 120
        action = "allow"
        from_port = 80
        to_port = 80
        cidr_block = var.pub-subnet2_cidr  
    }
    ingress {
        protocol = "tcp"
        rule_no = 125
        action = "allow"
        from_port = 1024
        to_port = 65535
        cidr_block =  "0.0.0.0/0" #pu1
    }
  
    egress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        from_port = 443
        to_port = 443
        cidr_block = "0.0.0.0/0"
    }
    egress{
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        from_port = 80
        to_port = 80
        cidr_block = "0.0.0.0/0"
    }
    egress {
        protocol = "tcp"
        rule_no = 120
        action = "allow"
        from_port = 1024
        to_port = 65535
        cidr_block = var.pub-subnet1_cidr ######
}

egress {
        protocol = "tcp"
        rule_no = 130
        action = "allow"
        from_port = 1024
        to_port = 65535
        cidr_block = var.pub-subnet2_cidr #####
    }
    egress {
        protocol = "tcp"
        rule_no = 140
        action = "allow"
        from_port = 0
        to_port = 65535
        cidr_block = var.db-subnet1_cidr
    }
    egress {
        protocol = "tcp"
        rule_no = 150
        action = "allow"
        from_port = 0
        to_port = 65535
        cidr_block = var.db-subnet2_cidr
    }
    tags = {
        Name = "${var.projectname}-nacl-priv"
    }
}

resource "aws_network_acl_association" "nacl-priv-assoc1" {
    network_acl_id = aws_network_acl.nacl-priv.id
    subnet_id = aws_subnet.priv-subnet1.id
}

resource "aws_network_acl_association" "nacl-priv-assoc2" {
    network_acl_id = aws_network_acl.nacl-priv.id
    subnet_id = aws_subnet.priv-subnet2.id
}


resource "aws_subnet" "db-subnet1" {
  vpc_id            = aws_vpc.cldsec-vpc.id
  cidr_block        = var.db-subnet1_cidr
  availability_zone = var.db-subnet1_az
  tags = {
    Name = "${var.projectname}-db-subnet1"
  }
}
resource "aws_subnet" "db-subnet2" {
  vpc_id            = aws_vpc.cldsec-vpc.id
  cidr_block        = var.db-subnet2_cidr
  availability_zone = var.db-subnet2_az
  tags = {
    Name = "${var.projectname}-db-subnet2"
  }
}
resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.cldsec-vpc.id
   tags = {
        Name = "${var.projectname}-db-rt"
    }
}

resource "aws_route_table_association" "db-rt-assoc" {
    subnet_id = aws_subnet.db-subnet1.id
    route_table_id = aws_route_table.db-rt.id
}

resource "aws_route_table_association" "db-rt-assoc2" {
    subnet_id = aws_subnet.db-subnet2.id
    route_table_id = aws_route_table.db-rt.id
  
}

resource "aws_network_acl" "nacl-db" {
    vpc_id = aws_vpc.cldsec-vpc.id
    subnet_ids = [aws_subnet.db-subnet1.id, aws_subnet.db-subnet2.id]
    
    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        from_port = 5432
        to_port = 5432
        cidr_block = var.priv-subnet1_cidr
    }
    ingress {
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        from_port = 5432
        to_port = 5432
        cidr_block = var.priv-subnet2_cidr
    }
    egress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        from_port = 0
        to_port = 65535
        cidr_block = var.priv-subnet1_cidr
    }
    egress {
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        from_port = 0
        to_port = 65535
        cidr_block = var.priv-subnet2_cidr
    }
 
}




