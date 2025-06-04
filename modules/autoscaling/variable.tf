variable "stage" {
    description = "deployment stage (e.g. dev, release, prod)"
    type        = string
}

variable "service_name" {
    description = "name of the service"
    type        = string
    default     = "meowng"
}

variable "launch_template_id" {
    description = "ID of the launch template to use for the autoscaling group"
    type        = string
}

variable "launch_template_version" {
    description = "version of the launch template (e.g. \"$Latest\" or a specific version number)"
    type        = string
    default     = "$Latest"
}

variable "vpc_zone_identifier" {
    description = "list of subnet IDs (public or private) for the autoscaling group"
    type        = list(string)
}

variable "min_size" {
    description = "minimum number of instances in the Auto Scaling Group"
    type        = number
    default     = 1
}

variable "max_size" {
    description = "maximum number of instances in the Auto Scaling Group"
    type        = number
    default     = 3
}

variable "desired_capacity" {
    description = "desired (initial) number of instances in the Auto Scaling Group"
    type        = number
    default     = 1
}

variable "scale_out_adjustment" {
    description = "number of instances to add when scaling out (ChangeInCapacity, positive)"
    type        = number
    default     = 1
}

variable "scale_in_adjustment" {
    description = "number of instances to remove when scaling in (ChangeInCapacity, negative)"
    type        = number
    default     = -1
}

variable "scale_out_cooldown" {
    description = "cooldown period (in seconds) after a scale-out action"
    type        = number
    default     = 300
}

variable "scale_in_cooldown" {
    description = "cooldown period (in seconds) after a scale-in action"
    type        = number
    default     = 300
}

variable "cpu_high_threshold" {
    description = "CPU utilization threshold above which a scale-out alarm will trigger"
    type        = number
    default     = 80
}

variable "cpu_low_threshold" {
    description = "CPU utilization threshold below which a scale-in alarm will trigger"
    type        = number
    default     = 20
}

variable "evaluation_periods" {
    description = "number of consecutie periods Cloudwatch evaluates CPU usage"
    type        = number
    default     = 2
}

variable "metric_period"{
    description = "CloudWatch metric period (in seconds)"
    type        = number
    default     = 300
}

variable "sns_topic_arn" {
    description = "SNS Topic ARN to notify when alarm trigger (empty if none)"
    type        = string
    default     = ""
}
