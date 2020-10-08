provider "aws" {
  alias                   = "aws_18f_infrastructure_mgmt"
  region                  = var.region
  assume_role             {
    role_arn                    = "arn:aws:iam::570696747145:role/CrossAccountAdmin"
  }
}

module "sub_common_18f_infrastructure_mgmt" {
  source                  = "../modules/sub_common"

  canonical_account_id    = var.canonical_account_id
  enable_tts_cloudtrail   = true

  providers               = {
    aws                       = aws.aws_18f_infrastructure_mgmt
  }
}
