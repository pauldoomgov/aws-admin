variable "backend_bucket" {
  type = "string"
}

variable "appenv" {
  description = "AWS region"
  default     = "sandbox"
}

variable "cc_account_id" {
  description = "cloudcheckr account id"
}

variable "cc_external_id" {
  description = "cloudcheckr external id"
}

variable "ip_whitelist" {
  description = "source IP whitelist"
}