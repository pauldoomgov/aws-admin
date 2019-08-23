provider "aws" {}

terraform {
  backend "s3" {
    region = "us-east-1"
  }
}

module "app" {
  source = "./app"
  appenv = "${var.appenv}"
}

module "iam" {
  source         = "./iam"
  env            = "${var.appenv}"
  aws_account_id = "${module.app.account_id}"
  is_production  = "${module.app.is_production}"
  is_test        = "${module.app.is_test}"
  is_staging     = "${module.app.is_staging}"
  is_development = "${module.app.is_development}"
  ip_whitelist   = "${var.ip_whitelist}"
}

module "guardduty" {
  source = "./guardduty"
}

module "cloudcheckr" {
  source            = "./cloudcheckr"
  account_id        = "${var.cc_account_id}"
  external_id       = "${var.cc_external_id}"
  enable            = "${module.app.is_development}"
  cloudtrail_bucket = "tts-${var.appenv}-logging"
}
