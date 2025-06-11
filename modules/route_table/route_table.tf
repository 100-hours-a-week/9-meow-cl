resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "${var.name_prefix}-public-rt"
    },
    var.tags
  )
}

resource "aws_route" "public_internet" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = var.igw_id
}

# public association
resource "aws_route_table_association" "public" {
  for_each = toset(var.public_subnet_ids)

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# private route tables (one per NAT gateway)
resource "aws_route_table" "private" {
    count = length(var.nat_gateway_ids)
    vpc_id = var.vpc_id
    tags = merge(
        {
            Name = "${var.name_prefix}-private-rt-${count.index}"
        },
        var.tags
    )
  
}

# private routes
# Make same number of route tables as NAT gateways
resource "aws_route" "private_nat" {
    count = length(var.nat_gateway_ids)
    route_table_id         = aws_route_table.private[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = var.nat_gateway_ids[count.index]
}

# private associations (spread across private RTs)
# route tables are mapped to private subnets in a round-robin fashion
# if there are 3 private subnets and 2 private route tables,
# the first subnet will be associated with the first route table,
# the second subnet with the second route table, and the third subnet with the first route table again.
# Make sure private subnets are input in the same order as NAT gateways
resource "aws_route_table_association" "private" {
  for_each       = toset(var.private_subnet_ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key % length(aws_route_table.private)].id
}

/*
module "route_table" {
  source              = "./modules/route_table"
  vpc_id              = module.vpc.vpc_id
  name_prefix         = var.name_prefix
  igw_id              = module.vpc.igw_id
  nat_gateway_ids     = module.nat.nat_gateway_ids
  public_subnet_ids   = module.subnet.public_subnet_ids

  # Private subnets must be listed in alternating AZ order
  # so that each subnet maps to the correct NAT-GW-backed RT:
  # [app-AZ-A, db-AZ-C, app-AZ-A, db-AZ-C, …]
  private_subnet_ids = [
    # 첫번째 AZ-A 서브넷
    module.subnet.app_subnet_ids[0], 
    # 두번째 AZ-C 서브넷
    module.subnet.db_subnet_ids[0],  
    # 세번째 AZ-A 서브넷
    module.subnet.app_subnet_ids[1], 
    # 네번째 AZ-C 서브넷
    module.subnet.db_subnet_ids[1],  
  ]

  tags = var.tags
}

*/