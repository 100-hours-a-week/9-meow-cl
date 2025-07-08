#frontend sg
data "aws_security_group" "frontend_sg" {
    filter {
        name = "group-name"
        values = ["SG-an2-frontend-stage-meowng"]
    }
}

data "aws_security_group" "backend_sg" {
    filter {
        name = "group-name"
        values = ["SG-an2-backend-stage-meowng"]
    }
}

data "aws_security_group" "db_sg" {
    filter {
        name = "group-name"
        values = ["SG-an2-db-stage-meowng"]
    }
}

data "aws_security_group" "sg_eks_cluster" {
    filter {
        name = "group-name"
        values = ["aws-sg-stage-meowng-eks-cluster"]
    }
}

data "aws_acm_certificate" "ssl_certificate" {
    domain   = "www.meowng.com"
    most_recent = true
    statuses = ["ISSUED"]
}

data "aws_ami" "frontend_ami" {
    most_recent = true
    owners      = ["self"]

    filter {
        name   = "name"
        values = ["ami-fe-prod-meowng-0625"]  # Adjust the filter to match your AMI naming convention
    }
}

## AMI NAMES

data "aws_ami" "backend_ami" {
    most_recent = true
    owners      = ["self"]

    filter {
        name   = "name"
        values = ["ami-backend-0706"]  # Adjust the filter to match your AMI naming convention
    }
}

data "aws_ami" "db_ami" {
    most_recent = true
    owners      = ["self"]

    filter {
        name   = "name"
        values = ["ami-db-prod-meonwg-0625"]  # Adjust the filter to match your AMI naming convention
    }
}

data "aws_iam_instance_profile" "iam_instance_profile" {
    name = "Meow-Prod-EC2-Role"
}

data "aws_launch_template" "launch_template_fe" {
    name = "lt-meowng-prod-frontend"
}

data "aws_launch_template" "launch_template_be" {
    name = "lt-meowng-prod-backend-v2"
}

data "aws_iam_role" "eks_cluster_role" {
    name = "IAM-Role-EKS_Cluster"
}

data "aws_iam_role" "eks_node_role" {
    name = "IAM-Role-eks-node-role"
}
