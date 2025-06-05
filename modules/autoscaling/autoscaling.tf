locals {
    common_tags = {
        Stage = var.stage
        ServiceName = var.service_name
    }
}

####################################################################
# 1) Auto Scaling Group 생성
####################################################################
resource "aws_autoscaling_group" "asg" {
    name_prefix         = "${var.service_name}-${var.stage}-asg-"
    launch_template{
        id = var.launch_template_id
        version = var.launch_template_version
    }
    vpc_zone_identifier = var.vpc_zone_identifier
    min_size            = var.min_size
    max_size            = var.max_size
    desired_capacity   = var.desired_capacity
    health_check_type  = "EC2"
    health_check_grace_period = 300
    force_delete       = true
    tag {
        key = "Stage"
        value = var.stage
        propagate_at_launch = true
    }
    tag {
        key = "ServiceName"
        value = var.service_name
        propagate_at_launch = true
    }
}

####################################################################
# 2) Scale-Out 정책
####################################################################
resource "aws_autoscaling_policy" "scale_out" {
    name = "${var.stage}-{var.service_name}-scale-out"
    autoscaling_group_name = aws_autoscaling_group.asg.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = var.scale_out_adjustment
    cooldown = var.scale_out_cooldown
}


####################################################################
# 3) Scale-In 정책
####################################################################
resource "aws_autoscaling_policy" "scale_in" {
    name = "${var.stage}-{var.service_name}-scale-in"
    autoscaling_group_name = aws_autoscaling_group.asg.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = var.scale_in_adjustment
    cooldown = var.scale_in_cooldown
}

####################################################################
# 4) CPU High 알람 → Scale-Out 트리거
####################################################################
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
    alarm_name = "${var.stage}-${var.service_name}-cpu-high"
    alarm_description = "Triggers scale-out when CPU > ${var.cpu_high_threshold}"
    namespace = "AWS/EC2"
    metric_name = "CPUUtilization"
    statistic = "Average"
    period = var.metric_period
    evaluation_periods = var.evaluation_periods
    threshold = var.cpu_high_threshold
    comparison_operator = "GreaterThanOrEqualToThreshold"

    dimensions = {
      AutoScalingGroupName = aws_autoscaling_group.asg.name
    }
    alarm_actions = (
        var.sns_topic_arn != ""
        ? [aws_autoscaling_policy.scale_out.arn, var.sns_topic_arn]
        : [aws_autoscaling_policy.scale_out.arn]
    )

    tags = local.common_tags
}

####################################################################
# 5) CPU Low 알람 → Scale-In 트리거
####################################################################
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
    alarm_name = "${var.stage}-${var.service_name}-cpu-low"
    alarm_description = "Triggers scale-in when CPU < ${var.cpu_low_threshold}"
    namespace = "AWS/EC2"
    metric_name = "CPUUtilization"
    statistic = "Average"
    period = var.metric_period
    evaluation_periods = var.evaluation_periods
    threshold = var.cpu_low_threshold
    comparison_operator = "LessThanOrEqualToThreshold"

    dimensions = {
      AutoScalingGroupName = aws_autoscaling_group.asg.name
    }
    alarm_actions = (
        var.sns_topic_arn != ""
        ? [aws_autoscaling_policy.scale_in.arn, var.sns_topic_arn]
        : [aws_autoscaling_policy.scale_in.arn]
    )
    tags = local.common_tags
}
