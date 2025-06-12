output "nat_gateway_id" {
  description = "Created NAT Gateway ID"
  value       = aws_nat_gateway.nat_gateway.id
}

output "nat_gateway_elastic_ip" {
  description = "Allocated Elastic IP Address"
  value       = var.allocate_eip ? aws_eip.nat_eip[0].public_ip : ""
}
