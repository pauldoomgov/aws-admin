variable "account_id" {
  description = "cloudcheckr account id"
}

variable "external_id" {
  description = "cloudcheckr external id"
}

variable "cloudtrail_bucket" {
  description = "cloudtrail bucket name"
  default     = ""
}

variable "enable" {
  description = "enable cloudcheckr module"
  default     = true
}

variable "enable_security" {
  description = "enable security access for cloudcheckr"
  default     = true
}

variable "enable_inventory" {
  description = "enable inventory access for cloudcheckr"
  default     = true
}

variable "enable_cloudwatch" {
  description = "enable cloudwatch flow logs access for cloudcheckr"
  default     = true
}
