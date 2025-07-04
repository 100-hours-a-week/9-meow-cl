# outputs.tf

# FE ALB
output "fe_alb_arn" {
  value = aws_lb.fe_alb.arn
}
output "fe_alb_dns_name" {
  value = aws_lb.fe_alb.dns_name
}

# BE ALB
output "be_alb_arn" {
  value = aws_lb.be_alb.arn
}
output "be_alb_dns_name" {
  value = aws_lb.be_alb.dns_name
}

# Target Group ARNs
output "alb_target_group_arns" {
  value = {
    frontend = aws_lb_target_group.frontend_tg.arn
    backend  = aws_lb_target_group.backend_tg.arn
  }
}

# FE Listener ARNs
output "fe_http_listener_arn" {
  value = aws_lb_listener.fe_http.arn
}
output "fe_https_listener_arn" {
  value = aws_lb_listener.fe_https.arn
}

# BE Listener ARN
output "be_http_listener_arn" {
  value = aws_lb_listener.be_http.arn
}
