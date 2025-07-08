resource "aws_security_group" "sg_alb_fe" {
    name       = "sg-alb-an2-${var.name_prefix}-${var.stage}-fe"
    vpc_id    = var.vpc_id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg_alb_be" {
    name       = "sg-alb-an2-${var.name_prefix}-${var.stage}-be"
    vpc_id    = var.vpc_id
    ingress {
        from_port   = var.backend_port
        to_port     = var.backend_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = var.db_port
        to_port     = var.db_port
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port  = var.redis_port
        to_port    = var.redis_port
        protocol   = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}