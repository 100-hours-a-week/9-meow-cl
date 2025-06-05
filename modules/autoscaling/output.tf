output "autoscaling_group_name" {
    description = "name of the created Auto Scaling Group"
  value = aws_autoscaling_group.asg.name
}

output "scale_out_policy_arn" {
  description = "ARN of the Scale-Out policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN of the Scale-In policy"
  value       = aws_autoscaling_policy.scale_in.arn
}

output "cpu_high_alarm_name" {
  description = "Name of the CPU High alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}

output "cpu_low_alarm_name" {
  description = "Name of the CPU Low alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_low.alarm_name
}

output "autoscaling_group_id" {
  description = "ID of the created Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}