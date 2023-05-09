# Get current region from provider
data "aws_region" "current" {}

# EKS cluster IAM trust policy
data "aws_iam_policy_document" "eks_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}