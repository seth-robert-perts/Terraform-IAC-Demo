# Get all available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get current region from provider
data "aws_region" "current" {}