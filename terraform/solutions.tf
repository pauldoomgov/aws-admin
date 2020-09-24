module "opp_prod" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "OPP Prod"
  org_unit_id = module.solutions.org_unit_id
}

module "opp_prod_setup" {
  source = "./account_setup"

  account_id              = module.opp_prod.account_id
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

module "data_gov" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "data.gov"
  org_unit_id = module.solutions.org_unit_id
}

module "data_gov_setup" {
  source = "./account_setup"

  account_id              = module.data_gov.account_id
  cross_account_role_name = local.role_name
}

# search.gov
module "search_gov" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "search.gov"
  org_unit_id = module.solutions.org_unit_id
}

module "search_gov_setup" {
  source = "./account_setup"

  account_id              = module.search_gov.account_id
  cross_account_role_name = local.role_name
}

# api.data.gov
module "api_data_gov" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "api-data-gov"
  org_unit_id = module.solutions.org_unit_id
}

module "api_data_gov_setup" {
  source = "./account_setup"

  account_id              = module.api_data_gov.account_id
  cross_account_role_name = local.role_name
}
