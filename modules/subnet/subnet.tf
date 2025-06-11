# public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      Name = "${var.name_prefix}-public-${count.index + 1}"
    },
    var.tags
  )
}
# application subnets
resource "aws_subnet" "app" {
  count = length(var.app_subnet_cidrs)

  vpc_id            = var.vpc_id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    {
      Name = "${var.name_prefix}-app-${count.index + 1}"
    },
    var.tags
  )
}
# database subnets
resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)

  vpc_id            = var.vpc_id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    {
      Name = "${var.name_prefix}-db-${count.index + 1}"
    },
    var.tags
  )
}

# example of make subnet in multiple AZs
/*
module "subnet" {
  source                  = "./modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  name_prefix             = "prod"                                  # 예: "prod" 환경
  azs                     = ["ap-northeast-2a", "ap-northeast-2c"]  # 2 AZ

  # Public 서브넷 CIDR(각 AZ당 하나씩)
  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]

  # App(Private) 서브넷 CIDR
  app_subnet_cidrs        = ["10.0.11.0/24", "10.0.12.0/24"]

  # DB(Private) 서브넷 CIDR
  db_subnet_cidrs         = ["10.0.21.0/24", "10.0.22.0/24"]

  map_public_ip_on_launch = true   # Public 서브넷에 Public IP 자동 할당
  tags                    = {
    Stage = "prod"
    Service_name     = "my-app"
  }
}
*/