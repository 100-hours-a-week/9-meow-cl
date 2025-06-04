locals {
  common_tags = {
    Stage       = var.stage
    ServiceName = var.service_name
  }
}

################################################
# 1) Log Group 생성
################################################
resource "aws_cloudwatch_log_group" "logs" {
  for_each = toset(var.log_groups)

  name              = "/${var.stage}/${each.value}"
  retention_in_days = 14       # 기본 보존 기간(필요시 변수로 분리 가능)
  tags              = local.common_tags
}

################################################
# 2) 기본 Metric Alarm 생성 (예: CPU Utilization)
################################################
resource "aws_cloudwatch_metric_alarm" "cpu" {
  for_each = toset(var.alarm_targets)

  alarm_name          = "${var.stage}-${each.key}-HighCPU"
  alarm_description   = "CPU Utilization > ${var.cpu_alarm_threshold}% for ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  datapoints_to_alarm = var.alarm_datapoints_to_alarm
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5분 단위
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  dimensions = {
    InstanceId = each.value
  }
  alarm_actions = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []
  tags         = local.common_tags
}

################################################
# 3) 커스텀 로그 필터(예: Error 탐지) - 선택 사항 예시
################################################
# (필요하다면 특정 패턴으로 Metric Filter 생성)
# resource "aws_cloudwatch_log_metric_filter" "errors" {
#   for_each = toset(var.log_groups)
#
#   name           = "${each.key}-ErrorFilter"
#   log_group_name = aws_cloudwatch_log_group.logs[each.key].name
#   pattern        = "{ $.level = \"ERROR\" }"
#   metric_transformation {
#     name      = "${each.key}-ErrorCount"
#     namespace = "${var.stage}/${var.service_name}"
#     value     = "1"
#   }
# }
/*
exmaple:
module "cloudwatch" {
  source        = "../modules/cloudwatch"
  stage         = var.stage
  service_name  = var.service_name

  log_groups         = ["openvpn", "app-backend", "app-frontend"]
  alarm_targets      = [module.openvpn.instance_id, module.backend.instance_id]
  cpu_alarm_threshold = 75
  alarm_evaluation_periods = 1
  alarm_datapoints_to_alarm = 1
  sns_topic_arn      = aws_sns_topic.alerts.arn
}

*/