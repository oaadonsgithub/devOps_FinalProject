
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }

   required_version = ">= 1.0.0"  # Optional version constraint
}


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
  tags = {
    Name = "terra-ubuntu-instance-${count.index}" 
  }

   user_data = <<-EOF
              #!/bin/bash
              apt-get update
              ssh-keygen -f mykey
              apt-get install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World" > /var/www/html/index.html
              systemctl restart apache2
              EOF
}



output "web-address" {
  value = "${aws_instance.terra_ubu.public_dns}:8080"
}

