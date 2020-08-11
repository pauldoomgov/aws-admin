module "data_gov_ssb" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "tts-datagov-ssb"
  org_unit_id = module.solutions.org_unit_id
}

module "data_gov_ssb_setup" {
  source = "./account_setup"

  account_id              = module.data_gov_ssb.account_id
  cross_account_role_name = local.role_name
}
