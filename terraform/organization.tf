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

resource "aws_organizations_organizational_unit" "u_18f" {
  provider  = aws.payer
  name      = "18F"
  parent_id = data.aws_organizations_organization.main.roots.0.id
}

resource "aws_organizations_organizational_unit" "cloud_gov" {
  provider  = aws.payer
  name      = "cloud.gov"
  parent_id = data.aws_organizations_organization.main.roots.0.id
}

resource "aws_organizations_organizational_unit" "coe" {
  provider  = aws.payer
  name      = "COE"
  parent_id = data.aws_organizations_organization.main.roots.0.id
}

resource "aws_organizations_organizational_unit" "login_gov" {
  provider  = aws.payer
  name      = "login.gov"
  parent_id = data.aws_organizations_organization.main.roots.0.id
}

resource "aws_organizations_organizational_unit" "opp" {
  provider  = aws.payer
  name      = "OPP"
  parent_id = data.aws_organizations_organization.main.roots.0.id
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
