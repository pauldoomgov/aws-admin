variable "canonical_account_id" {
  type = string
}

variable "enable_tts_cloudtrail" {
  description = "Enables the created trail to begin logging"
  default     = false
}
