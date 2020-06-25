provider "aws" {
  alias  = "payer"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::810504390172:role/CrossAccountAdmin"
  }
}

data "aws_organizations_organization" "main" {
  provider = aws.payer
}

module "u_18f" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "18f"
  email = "devops@gsa.gov"
}

module "cloud_gov" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "cloud-gov"
  email = "support@cloud.gov"
}

resource "aws_organizations_account" "cloud_gov_master" {
  provider = aws.payer

  name  = "tts-cloudgov-master"
  email = "devops+aws-cloudgov-master@gsa.gov"
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

module "coe" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "coe"
  email = "connectcoe@gsa.gov"
}

module "login_gov" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "login-gov"
  email = "security-team@login.gov"
}

module "solutions" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "solutions"
  email = "devops@gsa.gov"
}

module "tech_portfolio" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "tech-portfolio"
  email = "devops@gsa.gov"
}
