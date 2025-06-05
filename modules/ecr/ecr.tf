locals {
    #create a map of repository name with component name
    repo_name = { for comp in var.components : "${var.service_name}/${comp}" => comp }
}



resource "aws_ecr_repository" "ecr_repository" {
    for_each = local.repo_name
    name = each.value
    image_tag_mutability = var.image_tag_mutability
    image_scanning_configuration {
        scan_on_push = var.image_scanning   
    }
    tags = {
        Stage = var.stage
        ServiceName = var.service_name
        Component = each.key
    }
}

##############################
# 2) Create ECR Lifecycle Policy 
##############################

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
    for_each = {
        for comp, rules in var.lifecycle_rules_map : comp => rules
        if length(rules) > 0 
    }
    repository = aws_ecr_repository.ecr_repository[each.key].name
    # Convert the lifecycle rules to JSON format
    policy = jsonencode({
        rules = [
            for rule in each.value : {
              rulePriority = rule.rule_priority
              selection = {
                tagStatus   = rule.selection.tag_status
                countType   = rule.selection.count_type
                countNumber = rule.selection.count_number
              }
              action = { type = rule.action.type }
            }
        ]
    })
}
#example of calling this module
/*
module "ecr" {
  source               = "../modules/ecr"
  stage                = var.stage
  service_name         = var.service_name
  components           = ["9_meow_ai", "9_meow_be", "9_meow_fe"]
  image_scanning       = true
  image_tag_mutability = "IMMUTABLE"

  lifecycle_rules_map = {
    "9_meow_ai" = [
      {
        rule_priority = 1
        selection = {
          tag_status   = "any"
          count_type   = "imageCountMoreThan"
          count_number = 5
        }
        action = { type = "expire" }
      }
    ]
    "9_meow_be" = [
      {
        rule_priority = 10
        selection = {
          tag_status   = "tagged"
          count_type   = "sinceImagePushed"
          count_number = 30
        }
        action = { type = "expire" }
      }
    ]
    # "9_meow_fe" 는 default(empty)로 정책 없음
  }
}

*/