module "pif_gov" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "PIF"
  org_unit_id = module.PIF.org_unit_id
}

module "pif_gov_setup" {
  source = "./account_setup"

  account_id              = module.pif_gov.account_id
  cross_account_role_name = local.role_name
}
