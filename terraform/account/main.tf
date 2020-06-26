resource "aws_organizations_account" "account" {
  name                       = var.name
  email                      = "devops+aws-${replace(var.name, "tts-", "")}@gsa.gov"
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = var.org_unit_id

  lifecycle {
    ignore_changes  = [email, role_name]
    prevent_destroy = true
  }
}

provider "aws" {
  alias  = "child"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.account.id}:role/${var.cross_account_role_name}"
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
