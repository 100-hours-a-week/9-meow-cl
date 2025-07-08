# infra/stage/provider.tf
provider "aws" {
  region  = var.region
  # CI/CD 에서 assume-role 쓸 거면 profile 대신 아래처럼도 가능합니다.
  # assume_role {
  #   role_arn = var.assume_role_arn
  # }
}
