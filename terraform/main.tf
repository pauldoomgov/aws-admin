terraform {
  required_version = "~> 0.12.0"

  backend "s3" {
    # needs to match bootstrap module
    bucket         = "tts-aws-admin"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-admin-terraform-state-lock"
  }
}

# jump account
provider "aws" {
  version = "~> 2.32"
  # arbitrary, since most of these resources are global
  region = "us-east-1"
}

resource "aws_iam_group" "admins" {
  name = "tts-tech-portfolio-admins"
}
