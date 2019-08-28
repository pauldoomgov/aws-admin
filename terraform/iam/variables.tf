variable "env" {
  description = "AWS region to launch servers."
  default     = "sandbox"
}

variable "idp_url" {
  description = "Identity Provider URL"
  default = "idp.int.identitysandbox.gov"
}

variable "is_development" {
  description = "is the current environment development? returns 1 (true) or 0 (false)"
}

variable "is_test" {
  description = "is the current environment test? returns 1 (true) or 0 (false)"
}

variable "is_staging" {
  description = "is the current environment staging? returns 1 (true) or 0 (false)"
}
variable "is_production" {
  description = "is the current environment production? returns 1 (true) or 0 (false)"
}

variable "aws_account_id" {
  description = "aws account ID"
}

variable "ip_whitelist" {
  description = "source IP whitelist"
}
