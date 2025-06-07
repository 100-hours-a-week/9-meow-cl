output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_target_group_arns" {
  description = "The ARNs of the ALB target groups"
  value = {
    frontend = aws_lb_target_group.frontend_tg.arn
    backend  = aws_lb_target_group.backend_tg.arn
    ai       = aws_lb_target_group.ai_tg.arn
  }
}

output "alb_listener_http_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "alb_listener_https_arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}