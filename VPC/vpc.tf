#1.vpc 
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "demo-vpc"
    managed_by = "terraform"
  }
}

# 2.internet_gateway

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "demo-igw"
    Managed_by = "terraform"
  }
}

# 3.Public subnet

resource "aws_subnet" "pub_subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "demo-public-subnet"
    Managed_by = "terraform"
  }
}

# 4.private subnet

resource "aws_subnet" "pri_subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "demo-private-subnet"
    Managed_by = "terraform"
  }
}

# 5.public RT 1

resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
    Name = "demo-public-rt1"
    Managed_by = "terraform"
  }
}

# 6.private RT 1

resource "aws_route_table" "pri_rt1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "demo-private-rt1"
    Managed_by = "terraform"
  }
}

# 7.public RT 1 association

resource "aws_route_table_association" "pub_rt1_association" {
  subnet_id      = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.pub_rt1.id
}

# 8.private RT 1 association

resource "aws_route_table_association" "pri_rt1_association" {
  subnet_id      = aws_subnet.pri_subnet1.id
  route_table_id = aws_route_table.pri_rt1.id
}

# 9.security group

resource "aws_security_group" "sg1" {
  name        = "demo-sg1"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["172.10.11.0/24", aws_vpc.vpc1.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-sg1"
  }
}