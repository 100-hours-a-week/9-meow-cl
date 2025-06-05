variable "stage" {
  description = "deployment stage (e.g. dev, release, prod)"
  type        = string
}

variable "service_name" {
  description = "name of the service"
  type        = string
}

# 1) 로그 그룹 생성용 이름 리스트 (예: ["openvpn", "app-backend", "app-frontend"])
variable "log_groups" {
  description = "list of log groups to create"
  type        = list(string)
  default     = []
}

# 2) 메트릭 알람을 붙일 대상(예: EC2, RDS, ALB 등)의 ARN 리스트
variable "alarm_targets" {
  description = <<-EOT
    list of targets to attach alarms to (ARN format).
    create basic alarms for CPU, memory, and traffic.
  EOT
  type    = list(string)
  default = []
}

# 3) 알람 임계치 설정 (default 값 예시)
variable "cpu_alarm_threshold" {
  description = "CPU utilization alarm threshold (%)"
  type        = number
  default     = 80
}

variable "alarm_evaluation_periods" {
  description = "number of periods to evaluate the alarm"
  type        = number
  default     = 2
}

variable "alarm_datapoints_to_alarm" {
  description = "number of datapoints that must be breaching to trigger an alarm"
  type        = number
  default     = 2
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to notify when alarms occur"
  type        = string
  default     = ""
}
