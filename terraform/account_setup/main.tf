provider "aws" {
  alias  = "child"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.cross_account_role_name}"
  }
}

data "aws_caller_identity" "jump_account" {}

resource "aws_iam_group" "admins" {
  provider = aws.child

  name = "Administrators"
}

resource "aws_iam_group_policy_attachment" "admin" {
  provider = aws.child

  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "tts_securityaudit_role" {
  provider = aws.child
  name = "tts_securityaudit_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.jump_account.account_id}:root"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tts_securityaudit_role" {
  provider = aws.child
  role       = aws_iam_role.tts_securityaudit_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}