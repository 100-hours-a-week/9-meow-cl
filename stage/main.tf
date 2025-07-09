module "vpc" {
    source = "../modules/vpc"
    vpc_cidr = var.vpc_cidr
    name_prefix = "${var.service_name}-${var.stage}"
}

module "subnets" {
    source = "../modules/subnet"
    vpc_id = module.vpc.vpc_id
    name_prefix = "subnet-${var.service_name}-${var.stage}"
    azs = var.azs
    public_subnet_cidrs = var.public_subnet_cidrs
    app_subnet_cidrs = var.app_subnet_cidrs
    db_subnet_cidrs = var.db_subnet_cidrs
    map_public_ip_on_launch = var.map_public_ip_on_launch
    tags = var.tags
}

module "openvpn" {
    source = "../modules/openvpn"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.subnets.public_subnet_ids[0]
    key_name = var.key_name
}

module "nat_gateway_a" {
    source = "../modules/nat"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.subnets.public_subnet_ids[0]
}

module "nat_gateway_c" {
    source = "../modules/nat"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.subnets.public_subnet_ids[1] 
}

module "route_table" {
    source = "../modules/route_table"
    vpc_id = module.vpc.vpc_id
    name_prefix = "${var.service_name}-${var.stage}"
    public_subnet_ids = module.subnets.public_subnet_ids
    private_subnet_ids = [
        module.subnets.app_subnet_ids[0],
        module.subnets.app_subnet_ids[1],
        module.subnets.db_subnet_ids[0],
        module.subnets.db_subnet_ids[1]
    ]
    igw_id = module.vpc.igw_id  
    nat_gateway_ids = [
        module.nat_gateway_a.nat_gateway_id,
        module.nat_gateway_c.nat_gateway_id
    ]
}

module "alb" {
  source = "../modules/alb"     # 모듈 경로
  # 네이밍 관련
  service_name  = var.service_name    # ex: "meowng"
  stage         = var.stage           # ex: "stage"
  # 네트워크 설정
  frontend_subnet_ids           = module.subnets.app_subnet_ids
  backend_subnet_ids            = module.subnets.app_subnet_ids
  vpc_id                        = module.vpc.vpc_id  # VPC ID
  # 포트 설정
  frontend_port = var.frontend_port  # 3000(?) -> 수정 필요..?
  backend_port  = var.backend_port   # 8080
  # 공통 태그 & SSL 인증서
  certificate_arn = data.aws_acm_certificate.ssl_certificate.arn
}

module "instance_frontend" {
    source = "../modules/ec2"
    name_prefix = "ec2-${var.service_name}-${var.stage}"
    app_type = "frontend"
    stage = var.stage
    service_name = var.service_name
    ami_id = data.aws_ami.frontend_ami.id
    instance_type = "t3.small"  # Example instance type, adjust as needed
    key_name = var.key_name
    subnet_id = module.subnets.app_subnet_ids[0]  # Use the first AZ for the frontend
    availability_zone = var.azs[0]  # Use the first AZ for the frontend
    security_group_ids = [data.aws_security_group.frontend_sg.id]
    iam_instance_profile = data.aws_iam_instance_profile.iam_instance_profile
}

module "instance_backend" {
    source = "../modules/ec2"
    name_prefix = "ec2-${var.service_name}-${var.stage}"
    app_type = "backend"
    stage = var.stage
    service_name = var.service_name
    ami_id = data.aws_ami.backend_ami.id
    instance_type = "t3.small"  # Example instance type, adjust as needed
    key_name = var.key_name
    subnet_id = module.subnets.app_subnet_ids[0]  # Use the first AZ for the backend
    availability_zone = var.azs[0]  # Use the first AZ for the frontend
    security_group_ids = [data.aws_security_group.backend_sg.id]
    iam_instance_profile = data.aws_iam_instance_profile.iam_instance_profile
}

module "instance_db" {
    source = "../modules/ec2"
    name_prefix = "ec2-${var.service_name}-${var.stage}"
    app_type = "db"
    stage = var.stage
    service_name = var.service_name
    ami_id = data.aws_ami.db_ami.id
    instance_type = "t3.small"  # Example instance type, adjust as needed
    key_name = var.key_name
    subnet_id = module.subnets.app_subnet_ids[0]  # Use the first AZ for the backend
    availability_zone = var.azs[0]  # Use the first AZ for the frontend
    security_group_ids = [data.aws_security_group.db_sg.id]
    iam_instance_profile = data.aws_iam_instance_profile.iam_instance_profile
}
#####################################
####### auto scaling group ##########
#####################################

module "asg_frontend" {
    ### asg for frontend
    source = "../modules/autoscaling"
    stage = var.stage
    service_name = var.service_name
    app_name = "frontend"
    launch_template_id = data.aws_launch_template.launch_template_fe.id
    vpc_zone_identifier = module.subnets.app_subnet_ids
    min_size = 1
    max_size = 3
    desired_capacity = 1
    cpu_high_threshold = 70
}

module "asg_backend" {
    ### asg for backend
    source = "../modules/autoscaling"
    stage = var.stage
    service_name = var.service_name
    app_name = "backend"
    launch_template_id = data.aws_launch_template.launch_template_be.id
    vpc_zone_identifier = module.subnets.app_subnet_ids
    min_size = 1
    max_size = 3
    desired_capacity = 1
    cpu_high_threshold = 70
}


module "eks_cluster" {
    source = "../modules/eks"
    service_name = var.service_name
    stage = var.stage
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.subnets.app_subnet_ids
    tags = var.tags

    sg_eks_cluster_ingress_list = var.sg_eks_cluster_ingress_list ## Allowed IP addresses for EKS cluster ingress
    sg_allow_comm_ing = var.sg_allow_comm_ing
    service_ipv4_cidr = var.service_ipv4_cidr 
    desired_size         = var.desired_size
    min_size             = var.min_size
    max_size             = var.max_size
    max_unavailable      = var.max_unavailable
    ami_type             = var.ami_type
}