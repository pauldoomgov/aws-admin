locals {
  opp_prod_account_id  = "765358534566"
  data_gov_account_id  = "587807691409"
  search_gov_account_id  = "213305845712"
  api_data_gov_account_id  = "195022191070"    
}

module "opp_prod_setup" {
  source = "./account_setup"

  account_id              = local.opp_prod_account_id
  cross_account_role_name = local.role_name
}

# data.gov
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

module "data_gov_setup" {
  source = "./account_setup"

  account_id              = local.data_gov_account_id
  cross_account_role_name = local.role_name
}

# search.gov

module "search_gov_setup" {
  source = "./account_setup"

  account_id              = local.search_gov_account_id
  cross_account_role_name = local.role_name
}

# api.data.gov

module "api_data_gov_setup" {
  source = "./account_setup"

  account_id              = local.api_data_gov_account_id
  cross_account_role_name = local.role_name
}
