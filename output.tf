#########
# Output
#########
output "vpc" {
  value       = aws_vpc.this
  description = "The VPC resource object."
}

output "subnets" {
  value       = aws_subnet.this
  description = "A map of subnet resource objects."
}
