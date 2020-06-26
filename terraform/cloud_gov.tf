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

  name  = "tts-cloudgov-jump"
  email = "devops+aws-cloudgov-jump@gsa.gov"
  iam_user_access_to_billing = "ALLOW"
  parent_id = module.cloud_gov.org_unit_id
}

resource "aws_organizations_account" "cloud_gov_sandbox" {
  provider = aws.payer

  name  = "tts-cloudgov-sandbox"
  email = "devops+aws-cloudgov-sandbox@gsa.gov"
  iam_user_access_to_billing = "ALLOW"
  parent_id = module.cloud_gov.org_unit_id
}
