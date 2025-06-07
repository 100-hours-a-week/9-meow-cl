# ---------------------------------------
#   ALB
# ---------------------------------------
resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]

  tags = merge(
    local.default_tags,
    {
      Name = "${var.name_prefix}-${var.common_tags.Environment}-alb"
    }
  )
}

# ---------------------------------------
#   ALB Target Groups
#   - AI (8000)
#   - BE (8080)
#   - FE (3000)
# ---------------------------------------
resource "aws_lb_target_group" "ai_tg" {
  name     = "${var.name_prefix}-${var.common_tags.Environment}-ai-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthcheck"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${var.name_prefix}-${var.common_tags.Environment}-ai-tg"
    }
  )
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "${var.name_prefix}-${var.common_tags.Environment}-backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthcheck"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${var.name_prefix}-${var.common_tags.Environment}-backend-tg"
    }
  )
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = "${var.name_prefix}-${var.common_tags.Environment}-frontend-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${var.name_prefix}-${var.common_tags.Environment}-frontend-tg"
    }
  )
}

# ---------------------------------------
#   ALB Listeners
#   - HTTP (80)   : Redirect traffic to HTTPS
#   - HTTPS (443) : Forward traffic based on path
#                   "/api/*" -> backend_tg -> backend application
#                   "/ai/*"  -> ai_tg -> AI server
#                   "/"      -> frontend_tg -> React SPA
# ---------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "301"
    }
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${var.name_prefix}-${var.common_tags.Environment}-http-listener"
    }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }

  rules {
    action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.backend_tg.arn
    }

    condition {
      field  = "path-pattern"
      values = ["/api/*"]
    }
  }

  rules {
    action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.ai_tg.arn
    }

    condition {
      field  = "path-pattern"
      values = ["/ai/*"]
    }
  }

  rules {
    action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.frontend_tg.arn
    }

    condition {
      field  = "path-pattern"
      values = ["/"]
    }
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${var.name_prefix}-${var.common_tags.Environment}-https-listener"
    }
  )
}



