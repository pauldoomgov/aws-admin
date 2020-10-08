variable "canonical_account_id" {
  description = "AWS Account ID used as the identity source"
  default     = "133032889584"
}

variable "tts_payer_account_id" {
  description = "AWS Account ID for consolidated billing"
  default     = "810504390172"
}

variable "region" {
  description = "Region for AWS operations"
  default     = "us-west-2"
}
