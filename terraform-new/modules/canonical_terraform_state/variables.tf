variable "tfstate_bucket_name_prefix" {
  description   = "S3 Bucket name prefix used for tfstate for all OTHER repos (not this one)"
  default       = "tts-terraform"
}

variable "tfstate_table_name_prefix" {
  description   = "DynamoDB Table name prefix used for tfstate locking for all OTHER repos (not this one)"
  default       = "tts-terraform"
}

variable "tfstate_managed_repositories" {
  description   = "List of git repositories for which we managed terraform state"
  default       = ["tts-tech-portfolio"]
}
