provider "aws" {
}

# Include the securityaudit role in the common configuration
module "sub_securityaudit" {
  source                = "../sub_securityaudit"

  canonical_account_id  = var.canonical_account_id

  providers             = {
    aws                     = aws
  }
}

# Include the cloudtrail configuration in the common configuration
module "sub_cloudtrail" {
  source                = "../sub_cloudtrail"

  providers             = {
    aws                     = aws
  }

  enable_tts_cloudtrail = var.enable_tts_cloudtrail
}
