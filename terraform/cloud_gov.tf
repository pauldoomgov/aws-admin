module "cloud_gov" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "cloud-gov"
  email = "support@cloud.gov"
}

module "cloud_gov_jump" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name                    = "tts-cloudgov-jump"
  org_unit_id             = module.cloud_gov.org_unit_id
  cross_account_role_name = var.role_name
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
