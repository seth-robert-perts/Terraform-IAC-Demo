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

