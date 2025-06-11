# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = "${var.name_prefix}-vpc" },
    var.tags
  )
}

# Internet Gateway 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "${var.name_prefix}-igw" },
    var.tags
  )
}
