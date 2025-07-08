locals {
  default_tags = {
    service_name = var.service_name
    Environment  = var.stage
  }
}

# -----------------------------
# FE용 ALB
# -----------------------------
resource "aws_lb" "fe_alb" {
  name               = "${var.name_prefix}-${var.stage}-fe-${var.service_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.frontend_subnet_ids
  security_groups    = [aws_security_group.sg_alb_fe.id]

  tags = merge(
    local.default_tags,
    { Name = "${var.name_prefix}-${var.stage}-fe-${var.service_name}" }
  )
}

resource "aws_lb_listener" "fe_http" {
  load_balancer_arn = aws_lb.fe_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    local.default_tags,
    { Name = "${var.name_prefix}-${var.stage}-fe-http-listener" }
  )
}

resource "aws_lb_listener" "fe_https" {
  load_balancer_arn = aws_lb.fe_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }

  tags = merge(
    local.default_tags,
    { Name = "${var.name_prefix}-${var.stage}-fe-https-listener" }
  )
}

resource "aws_lb_listener_rule" "fe_api" {
  listener_arn = aws_lb_listener.fe_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }

  tags = merge(
    local.default_tags,
    { Name = "${var.name_prefix}-${var.stage}-fe-rule-api" }
  )
}


# -----------------------------
# BE용 ALB
# -----------------------------
resource "aws_lb" "be_alb" {
  name               = "${var.name_prefix}-${var.stage}-be-${var.service_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.backend_subnet_ids
  security_groups    = [aws_security_group.sg_alb_be.id]

  tags = merge(
    local.default_tags,
    { Name = "${var.name_prefix}-${var.stage}-be-${var.service_name}" }
  )
}

resource "aws_lb_listener" "be_http" {
  load_balancer_arn = aws_lb.be_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  tags = merge(
    local.default_tags,
    { Name = "${var.name_prefix}-${var.stage}-be-http-listener" }
  )
}
