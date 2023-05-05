# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "Terraform-CLI"

  default_tags {
    tags = {
      Terraform-Generated = true
      Project             = "EKS Cluster Demo"
    }
  }
}

# Create VPC for EKS
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "EKS-VPC"
  }
}

# Create public subnets for load balancers
resource "aws_subnet" "public" {
  for_each = local.public_subnet_info

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = each.value["public_ip"]

  tags = each.value["tags"]
}

# Create subnets for EKS control plane and data plane
resource "aws_subnet" "private" {
  for_each = local.private_subnet_info

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = each.value["public_ip"]

  tags = each.value["tags"]
}

# Create internet gateway for public subnets
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "Main-Internet-Gateway"
  }
}

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Create private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route = []

  tags = {
    Name = "Private-Route-Table"
  }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Associate private route table with private subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Create open seurity group for interface endpoints
resource "aws_security_group" "full_open" {
  name        = "full_open"
  description = "Fully open security group"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow all ingress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Full-Open"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create interface endpoints for private subnets to connect to AWS services
resource "aws_vpc_endpoint" "endpoints" {
  for_each = local.endpoints

  vpc_id            = aws_vpc.this.id
  service_name      = each.value["service_name"]
  vpc_endpoint_type = each.value["vpc_endpoint_type"]
  subnet_ids = [for key, value in aws_subnet.private : value.id]
  security_group_ids = [
    aws_security_group.full_open.id,
  ]
  
  tags = {
    Name = each.key
  }
}