locals {

  # Break VPC cidr into 4 equal subnets
  subnet_cidr = [for i in range(4) : cidrsubnet(var.vpc_cidr, 2, i)]

  # Create public subnet map
  public_subnet_info = {
    public-1 = {
      az        = data.aws_availability_zones.available.names[0]
      cidr      = local.subnet_cidr[0]
      public_ip = true
      tags = {
        "Name"                   = "EKS-Subnet-Public-1"
        "kubernetes.io/role/elb" = 1
      }
    }
    public-2 = {
      az        = data.aws_availability_zones.available.names[1]
      cidr      = local.subnet_cidr[1]
      public_ip = true
      tags = {
        "Name"                   = "EKS-Subnet-Public-2"
        "kubernetes.io/role/elb" = 1
      }
    }
  }

  # Create public subnet map
  private_subnet_info = {
    private-1 = {
      az        = data.aws_availability_zones.available.names[2]
      cidr      = local.subnet_cidr[2]
      public_ip = false
      tags = {
        "Name"                            = "EKS-Subnet-Private-1"
        "kubernetes.io/role/internal-elb" = 1
      }
    }
    private-2 = {
      az        = data.aws_availability_zones.available.names[3]
      cidr      = local.subnet_cidr[3]
      public_ip = false
      tags = {
        "Name"                            = "EKS-Subnet-Private-2"
        "kubernetes.io/role/internal-elb" = 1
      }
    }
  }

  # Interface endpoints for private subnets
  endpoints = {
    ec2 = {
      service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2"
      vpc_endpoint_type = "Interface"
    }
    ecr_api = {
      service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
      vpc_endpoint_type = "Interface"
    }
    ecr_dkr = {
      service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
      vpc_endpoint_type = "Interface"
    }
    s3 = {
      service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
      vpc_endpoint_type = "Interface"
    }
    sts = {
      service_name      = "com.amazonaws.${data.aws_region.current.name}.sts"
      vpc_endpoint_type = "Interface"
    }
    cloudwatch = {
      service_name      = "com.amazonaws.${data.aws_region.current.name}.logs"
      vpc_endpoint_type = "Interface"
    }
  }
}


