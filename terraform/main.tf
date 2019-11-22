terraform {
  backend "s3" {
    # needs to match bootstrap module
    bucket         = "tts-aws-admin"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-admin-terraform-state-lock"
  }
}

provider "aws" {
  version = "~> 2.32"
  region  = "us-east-1"
}

resource "aws_iam_group" "admins" {
  name = "tts-tech-portfolio-admins"
}

data "aws_iam_policy_document" "cross_account" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [for acct in data.aws_organizations_organization.main.accounts : "arn:aws:iam::${acct.id}:role/${var.role_name}"]
  }
}

resource "aws_iam_policy" "assume_role" {
  name   = "allow-assume-cross-account-role"
  policy = "${data.aws_iam_policy_document.cross_account.json}"
}

resource "aws_iam_group_policy_attachment" "assume_role" {
  group      = "${aws_iam_group.admins.name}"
  policy_arn = "${aws_iam_policy.assume_role.arn}"
}
