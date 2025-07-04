terraform {
  backend "s3" {
    bucket         = "s3-meowng-terraform-state"
    key            = "stage/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "meowng-terraform-state"
    encrypt        = true
  }
}
