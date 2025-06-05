output "openvpn_instance_id" {
  description = "The ID of the OpenVPN EC2 instance"
  value       = aws_instance.openvpn.id
}

output "openvpn_public_ip" {
  description = "The public IP address of the OpenVPN server"
  value       = aws_instance.openvpn.public_ip
}

output "openvpn_security_group_id" {
  description = "The security group ID for the OpenVPN server"
  value       = aws_security_group.openvpn_sg.id
}
output "openvpn_eip" {
  description = "value of the OpenVPN EIP"
  value       = aws_eip.openvpn_eip.public_ip
}