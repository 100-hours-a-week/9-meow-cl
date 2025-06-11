output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "app_subnet_ids" {
  description = "IDs of the application subnets"
  value       = [for s in aws_subnet.app : s.id]
}

output "db_subnet_ids" {
  description = "IDs of the database subnets"
  value       = [for s in aws_subnet.db : s.id]
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "app_route_table_ids" {
  description = "The IDs of the application route tables"
  value       = [for rt in aws_route_table.app : rt.id]
}