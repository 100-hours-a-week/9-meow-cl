output "instance_ids" {
  description = "IDs of the created EC2 instance(s)"
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "Public IP addresses (if assigned)"
  value       = aws_instance.this[*].public_ip
}

output "private_ips" {
  description = "Private IP addresses"
  value       = aws_instance.this[*].private_ip
}