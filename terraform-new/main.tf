provider "aws" {
  region                        = var.region
}

# Define some locals
locals {
  terraform_s3_bucket           = "${var.state_control_prefix}-s3"
  terraform_dynamodb_table_base = "${var.state_control_prefix}-dynamodb"

  dynamodb_table_canonical      = "${local.terraform_dynamodb_table_base}-canonical"
  dynamodb_table_subordinate    = "${local.terraform_dynamodb_table_base}-subordinate"
#  accounts                      = {
#    "18f_infrastructure_mgmt"       = "570696747145"
#  }
}


##### BOILERPLATE CONFIG FOR CANONICAL ACCOUNT #######
# Define the remote state backend for the canonical account.  Variables cannot be used here
terraform {
  backend "s3" {
    bucket                          = "tts-terraform-s3"
    key                             = "aws-admin/canonical/terraform.tfstate"
    dynamodb_table                  = "tts-terraform-dynamodb-canonical"
    region                          = "us-west-2"
  }
}

data "aws_caller_identity" "current" {
}

# Define the S3 bucket holding terraform state
resource "aws_s3_bucket" "tf-state" {
  bucket                            = local.terraform_s3_bucket
  acl                               = "private"
  policy                            = ""
  versioning {
    enabled                             = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm                       = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy                     = true
  }
}

# Lock down the allowable policies on the terraform state bucket
resource "aws_s3_bucket_public_access_block" "tf-state" {
  bucket                            = aws_s3_bucket.tf-state.id

  block_public_acls                 = true
  block_public_policy               = true
  ignore_public_acls                = true
  restrict_public_buckets           = true
}

# Create the dynamoDB table used to track terraform locks for the canonical account
resource "aws_dynamodb_table" "tf-lock-table-canonical" {
  name                              = local.dynamodb_table_canonical
  read_capacity                     = 2
  write_capacity                    = 1
  hash_key                          = "LockID"

  attribute {
    name                                = "LockID"
    type                                = "S"
  }

  server_side_encryption {
    enabled                             = true
  }

  lifecycle {
    prevent_destroy                     = true
  }
}

# Create the dynamoDB table used to track terraform locks for the canonical account
resource "aws_dynamodb_table" "tf-lock-table-subordinate" {
  name                              = local.dynamodb_table_subordinate
  read_capacity                     = 2
  write_capacity                    = 1
  hash_key                          = "LockID"

  attribute {
    name                                = "LockID"
    type                                = "S"
  }

  server_side_encryption {
    enabled                             = true
  }

  lifecycle {
    prevent_destroy                     = true
  }
}

######## Canonical Account Management ############
module "canonical_iam" {
  source                  = "./modules/canonical_iam"
}

######## Managed Terraform State ###############
module "canonical_terraform_state" {
  source                  = "./modules/canonical_terraform_state"
}
