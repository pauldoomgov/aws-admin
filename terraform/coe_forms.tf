module "coe_forms_dev" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "tts-coe-forms-dev"
  org_unit_id = module.solutions.org_unit_id
}

module "coe_forms_dev_setup" {
  source = "./account_setup"

  account_id              = module.coe_forms_dev.account_id
  cross_account_role_name = var.role_name
}

module "coe_forms_test" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "tts-coe-forms-test"
  org_unit_id = module.solutions.org_unit_id
}

module "coe_forms_test_setup" {
  source = "./account_setup"

  account_id              = module.coe_forms_test.account_id
  cross_account_role_name = var.role_name
}

module "coe_forms_prod" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "tts-coe-forms-prod"
  org_unit_id = module.solutions.org_unit_id
}

module "coe_forms_prod_setup" {
  source = "./account_setup"

  account_id              = module.coe_forms_prod.account_id
  cross_account_role_name = var.role_name
}
