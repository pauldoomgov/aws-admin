provider "aws" {
  alias  = "payer"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::810504390172:role/${local.role_name}"
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

module "coe" {
  source = "./business_unit"
  providers = {
    aws = aws.payer
  }

  name  = "coe"
  email = "connectcoe@gsa.gov"
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
