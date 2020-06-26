module "cloud_gov" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "cloud-gov"
  email = "support@cloud.gov"
}

resource "aws_organizations_account" "cloud_gov_jump" {
  provider = aws.payer

  name                       = "tts-cloudgov-jump"
  email                      = "devops+aws-cloudgov-jump@gsa.gov"
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = module.cloud_gov.org_unit_id

  lifecycle {
    ignore_changes  = [email, role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "cloud_gov_sandbox" {
  provider = aws.payer

  name                       = "tts-cloudgov-sandbox"
  email                      = "devops+aws-cloudgov-sandbox@gsa.gov"
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = module.cloud_gov.org_unit_id

  lifecycle {
    ignore_changes  = [email, role_name]
    prevent_destroy = true
  }
}

provider "aws" {
  alias  = "cloud_gov_jump"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.cloud_gov_jump.id}:role/${var.role_name}"
  }
}

resource "aws_iam_group" "cloud_gov_jump_admins" {
  provider = aws.cloud_gov_jump

  name = "Administrators"
}

locals {
  admin_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "cloud_gov_jump_admin" {
  provider = aws.cloud_gov_jump

  group      = aws_iam_group.cloud_gov_jump_admins.name
  policy_arn = local.admin_policy_arn
}

resource "aws_iam_user" "peter_burkholder" {
  name = "peter.burkholder@gsa.gov"
}

resource "aws_iam_user_group_membership" "peter_burkholder_admin" {
  user   = aws_iam_user.peter_burkholder.name
  groups = [aws_iam_group.cloud_gov_jump_admins.name]
}
