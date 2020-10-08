provider "aws" {
  alias                   = "aws_datagov_ssb"
  region                  = var.region
  assume_role             {
    role_arn                    = "arn:aws:iam::821341638715:role/CrossAccountAdmin"
  }
}

module "sub_common_datagov_ssb" {
  source                  = "../modules/sub_common"

  canonical_account_id    = var.canonical_account_id

  providers               = {
    aws                       = aws.aws_datagov_ssb
  }
}
