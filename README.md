# Terraform-IAC-Demo

## Summary
Created an EKS cluster using Terraform and created reusable modules based on Terraform resources (everything is from scratch)

Followed Terraform Best Practices: https://www.terraform-best-practices.com/

## Features
- Fully private EKS cluster
- Modularized networking to allow reusability
- Utilizes VPC inferace endpoints to avoid public traffic to AWS services
- Creates 2 public and 2 private subnets (public subnets for load balancer and private for cluster)

## Terraform Features
- Modular design
- Version locked providers and modules ensuring reproducibility
- Separate file layout to grouping of various constructs
- Well commented and formated using (fmt)

Author: Seth Perts