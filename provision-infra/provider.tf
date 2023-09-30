provider "aws" {
  region = var.aws_region
}

# terraform {
#   backend "s3" {
#     bucket         = "project-capstone-devops-tfstate"
#     key            = "recipe-app.tfstate"
#     region         = "ap-northeast-1"
#     encrypt        = true
#     dynamodb_table = "recipe-app-api-devops-tf-state-lock"
#   }
# }
