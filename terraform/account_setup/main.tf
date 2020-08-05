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
  
resource "aws_iam_user" "readonly" {
  provider = aws.child

  name = "readonly"
}

resource "aws_iam_user_policy" "readonly" {
  name = "test"
  user = "${aws_iam_user.readonly.name}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "arn:aws:iam::${data.aws_organizations_account.account.id}:${aws_iam_user.readonly.name}" }
    }]
  })
}

resource "aws_iam_user_policy_attachment" "readonly" {
  provider = aws.child

  user       = "${aws_iam_user.readonly.name}"
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}