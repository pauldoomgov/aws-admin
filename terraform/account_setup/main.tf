provider "aws" {
  alias  = "child"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.cross_account_role_name}"
  }
}

resource "aws_iam_group" "admins" {
  provider = aws.child

  name = "Administrators"
}

resource "aws_iam_group_policy_attachment" "admin" {
  provider = aws.child

  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group" "securityaudit_group" {
  provider = aws.child

  name = "securityaudit"
}

resource "aws_iam_group_policy_attachment" "securityaudit" {
  provider = aws.child

  group      = aws_iam_group.securityaudit_group.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role" "role" {
  name = "cloudcustodian"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "arn:aws:iam::${var.account_id}:role/SecurityAudit" }
    }]
  })
  provider = aws.child
}

resource "aws_iam_role_policy_attachment" "cloudcustodian" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}