output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnet_private_ids" {
  description = "The private subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "subnet_public_ids" {
  description = "The public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}