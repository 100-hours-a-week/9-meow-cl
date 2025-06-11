output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.ec2[*].id
}

output "ec2_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.ec2[*].public_ip
}

output "ec2_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = aws_instance.ec2[*].private_ip
}

output "eip_id" {
  description = "The ID of the Elastic IP"
  value       = aws_eip.ec2_eip.id
}

output "eip_public_ip" {
  description = "The public IP address of the Elastic IP"
  value       = aws_eip.ec2_eip.public_ip
}