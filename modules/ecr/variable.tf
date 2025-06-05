variable "stage"{
    description = "The stage of the ECR repository"
    type        = string
    default     = "dev"
}

variable "service_name"{
    description = "The name of the service"
    type        = string
    default     = "meowng"
}

variable "components"{
    description = "list of name of ECR components (e.g. [\"9_meow_ai\",\"9_meow_be\",\"9_meow_fe\"])"
    type        = list(string)
    default     = ["9_meow_ai","9_meow_be","9_meow_fe"]
}

variable "image_scanning"{
    description = "The image scanning configuration"
    type        = bool
    default     = true
}

variable "image_tag_mutability"{
    description = "The image tag mutability"
    type        = string
    default     = "MUTABLE"
}

variable "lifecycle_rules_map" {
  description = <<-EOT
    Map for ECR component -> list of lifecycle rules.
    Each rule object should include:
    - rule_priority (number)
    - selection (object with tag_status, count_type, count_number)
    - action (object with type)
    EOT
  type = map(list(object({
    rule_priority = number
    selection = object({
      tag_status   = string
      count_type   = string
      count_number = number
    })
    action = object({
      type = string
    })
  })))
  default = {}  # NONE
}