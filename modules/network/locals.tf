locals {

  # Break VPC cidr into 4 equal subnets
  subnet_cidr = [for i in range(4) : cidrsubnet(var.vpc_cidr, 2, i)]

  # Create subnet info map
  subnet_info = {
    subnet1-public1 = {
      az   = data.aws_availability_zones.available.names[0]
      cidr = local.subnet_cidr[0]
    }
    subnet2-public2 = {
      az   = data.aws_availability_zones.available.names[1]
      cidr = local.subnet_cidr[1]
    }
    subnet3-private1 = {
      az   = data.aws_availability_zones.available.names[2]
      cidr = local.subnet_cidr[2]
    }
    subnet4-private2 = {
      az   = data.aws_availability_zones.available.names[3]
      cidr = local.subnet_cidr[3]
    }
  }
}