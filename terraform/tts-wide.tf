module "tts_jump" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "tts-prod"
  org_unit_id = module.tts-wide.org_unit_id
}

module "tts_jump_setup" {
  source = "./account_setup"

  account_id              = module.tts_jump.account_id
  cross_account_role_name = local.role_name
}

module "tts_payer" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "FPT202 GSA TTS Payer"
  org_unit_id = module.tts-wide.org_unit_id
}

module "tts_payer_setup" {
  source = "./account_setup"

  account_id              = module.tts_payer.account_id
  cross_account_role_name = local.role_name
}

module "u_18f_enterprise" {
  source = "./account"
  providers = {
    aws = aws.payer
  }

  name        = "18F Enterprise"
  org_unit_id = module.u_18f.org_unit_id
}

module "u_18f_enterprise_setup" {
  source = "./account_setup"

  account_id              = module.u_18f_enterprise.account_id
  cross_account_role_name = local.role_name
}
