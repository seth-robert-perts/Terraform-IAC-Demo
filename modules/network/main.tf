# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "Terraform-CLI"

  default_tags {
    tags = {
      Terraform-Generated = true
    }
  }
}

# Create VPC
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "EKS VPC"
  }
}
