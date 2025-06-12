provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "subnet" {
  source                  = "../modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  name_prefix             = var.name_prefix
  azs                     = var.azs
  public_subnet_cidrs     = var.public_subnet_cidrs
  app_subnet_cidrs        = var.app_subnet_cidrs
  db_subnet_cidrs         = var.db_subnet_cidrs
  map_public_ip_on_launch = true
  tags                    = var.tags
}

// create one NAT per public subnet in AZ order
module "nat" {
  for_each     = toset(module.subnet.public_subnet_ids)
  source        = "../modules/nat"
  stage         = var.stage
  service_name  = var.name_prefix
  vpc_id        = module.vpc.vpc_id
  subnet_id     = each.value
  allocate_eip  = true
}

module "route_table" {
  source             = "../modules/route_table"
  vpc_id             = module.vpc.vpc_id
  name_prefix        = var.name_prefix
  public_subnet_ids  = module.subnet.public_subnet_ids

  # private subnets must be listed alternating AZ order: app-A, db-C, app-C, db-A, …
  private_subnet_ids = concat(module.subnet.app_subnet_ids, module.subnet.db_subnet_ids)
  igw_id             = module.vpc.igw_id
  nat_gateway_ids    = [for n in module.nat : n.nat_gateway_id]
  tags               = var.tags
}
