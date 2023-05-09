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

resource "aws_iam_role" "eks_cluster" {
  name               = "EKS-Cluster-Role"
  assume_role_policy = data.aws_iam_policy_document.eks_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# Create log group for control plane logs
resource "aws_cloudwatch_log_group" "eks_control_plane" {

  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 1

  tags = {
    Name = "EKS-Control-Plane"
  }
}

# Create EKS cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    subnet_ids              = var.private_subnets
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  version                   = "1.25"

  tags = {
    Name = var.cluster_name
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  # Prevent ordering issues with EKS automatically creating the log group first and a variable for naming consistency.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_cloudwatch_log_group.eks_control_plane
  ]
}