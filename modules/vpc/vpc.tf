# ---------------------------------------
#   VPC (Prod)
# ---------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "${var.name_prefix}-vpc"
    },
    var.tags
  )
}

# ---------------------------------------
#   Internet Gateway
# ---------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.name_prefix}-igw"
    },
    var.tags
  )
}

# ---------------------------------------
#   NAT Gateway
# ---------------------------------------
resource "aws_eip" "nat" {
  count = length(aws_subnet.public)
  vpc   = true

  tags = merge(
    {
      Name = "${var.name_prefix}-nat-eip-${count.index}"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count         = length(aws_subnet.public)
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = merge(
    {
      Name = "${var.name_prefix}-nat-gw-${count.index}"
    },
    var.tags
  )
}

# ---------------------------------------
#   Subnet (public - app - db)
# ---------------------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs) # count = 1 (one subnet)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index] #count.index = 0
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.name_prefix}-public-${count.index}"
      Tier = "public"
    },
    var.tags
  )
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnet_cidrs) # count = 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    {
      Name = "${var.name_prefix}-app-${count.index}"
      Tier = "app"
    },
    var.tags
  )
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidrs) # count = 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    {
      Name = "${var.name_prefix}-db-${count.index}"
      Tier = "db"
    },
    var.tags
  )
}

# ---------------------------------------
#   Public routing
# ---------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.name_prefix}-public-rt"
    },
    var.tags
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------
#   Private routing
# ---------------------------------------
resource "aws_route_table" "app" {
  count  = length(aws_nat_gateway.nat)
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.name_prefix}-app-rt"
    },
    var.tags
  )
}

resource "aws_route" "app_nat_gateway" {
  count                  = length(aws_nat_gateway.nat)
  route_table_id         = aws_route_table.app[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "app" {
  count          = length(aws_subnet.app)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index % length(aws_route_table.app)].id
}

