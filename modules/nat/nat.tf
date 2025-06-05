locals {
  common_tags = {
    Stage      = var.stage
    Service    = var.service_name
  }
}

# 1) create Elastic IP (when allocated_eip is true)
resource "aws_eip" "nat_eip" {
  count = var.allocat_eip ? 1 : 0
  domain = "vpc" # Specify the domain as "vpc" for NAT Gateway
  tags = local.common_tags
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = var.allocat_eip ? aws_eip.nat_eip[0].id : var.allocated_eip_id
  subnet_id     = var.subnet_id
  tags = local.common_tags
}