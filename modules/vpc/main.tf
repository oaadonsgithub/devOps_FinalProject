# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1c"

  tags = {
    Name = "public"
  }
}


resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.20.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-1c"

  tags = {
    Name = "private"
  }
}


# Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main-public"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main-public.id
}


# Create multiple EC2 instances
resource "aws_instance" "terra_ubu" {
  count = 3 

  ami                    = "ami-0a07501f369088e6e"
  instance_type          = "t2.micro" 
  key_name               = aws_key_pair.mykeypair.key_name
  tags = {
    Name = "terra-ubuntu-instance-${count.index}" 
  }
}


# Create multiple EC2 instances
resource "aws_instance" "terra_aws" {
  count = 3 

  ami                    = "ami-09fdfbe62666994aa"
  instance_type          = "t2.micro" 
  key_name               = aws_key_pair.mykeypair.key_name
  tags = {
    Name = "terra-aws-instance-${count.index}" 
  }
}

