# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "Terraform-CLI"
}

# Create network for EKS cluster
module "network" {
  source = "./modules/network"
}

# Create EKS cluster
module "eks" {
  source = "./modules/eks"

  private_subnets = module.network.subnet_private_ids
}