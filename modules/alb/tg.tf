resource "aws_lb_target_group" "frontend_tg" {
  name     = "${var.name_prefix}-${var.stage}-frontend-tg"
  port     = var.frontend_port
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
    { Name = "${var.name_prefix}-${var.stage}-frontend-tg" }
  )
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "${var.name_prefix}-${var.stage}-backend-tg"
  port     = var.backend_port
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
    { Name = "${var.name_prefix}-${var.stage}-backend-tg" }
  )
}
