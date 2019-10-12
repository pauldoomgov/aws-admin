provider "aws" {
  version = "~> 2.32"
  region = "us-east-1"
}

resource "aws_iam_group" "admins" {
  name = "tts-tech-portfolio-admins"
}

data "aws_iam_policy_document" "cross_account" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [for acct in var.dest_account_numbers : "arn:aws:iam::${acct}:role/${var.role_name}"]
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

output "switch_role_urls" {
  value = { for acct in var.dest_account_numbers : "${acct}" => "https://signin.aws.amazon.com/switchrole?roleName=${var.role_name}&account=${acct}&displayName=${acct}" }
}
