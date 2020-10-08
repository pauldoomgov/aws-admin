# Define the remote state backend.  Variables cannot be used here
terraform {
  backend "s3" {
    bucket                      = "tts-terraform-s3"
    key                         = "aws-admin/subordinate/terraform.tfstate"
    dynamodb_table              = "tts-terraform-dynamodb-subordinate"
    region                      = "us-west-2"
  }
}
