output "log_group_names" {
  description = "list of created log group names"
  value = [
    for lg in aws_cloudwatch_log_group.logs : lg.name
  ]
}

output "cpu_alarm_names" {
  description = "list of created CPU Metric Alarm names"
  value = [
    for ma in aws_cloudwatch_metric_alarm.cpu : ma.alarm_name
  ]
}
