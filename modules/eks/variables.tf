variable "private_subnets" {
  description = "The private subnets that the EKS cluster should be deployed into"
  type        = list(any)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "Terraform-IAC-Demo"
}