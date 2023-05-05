# VPC cidr for cluster
variable "vpc_cidr" {
  description = "The CIDR to use for the EKS VPC"
  type        = string
  default     = "10.0.0.0/16"
}
