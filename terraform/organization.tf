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

  name              = "18F"
  budget_param_name = "18f"
  email             = "devops@gsa.gov"
}

module "cloud_gov" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name              = "cloud.gov"
  budget_param_name = "cloud.gov"
  email             = "support@cloud.gov"
}

module "coe" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name              = "Centers of Excellence"
  budget_param_name = "coe"
  email             = "connectcoe@gsa.gov"
}

module "login_gov" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name              = "login.gov"
  budget_param_name = "login.gov"
  email             = "security-team@login.gov"
}

module "solutions" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name              = "Solutions"
  budget_param_name = "solutions"
  email             = "devops@gsa.gov"
}

module "tech_portfolio" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name              = "Tech Portfolio"
  budget_param_name = "tech-portfolio"
  email             = "devops@gsa.gov"
}
