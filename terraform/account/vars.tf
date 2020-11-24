variable "name" {
  type = string
}

variable "org_unit_id" {
  type = string
}

variable "daily_budget_usd" {
  description = "Daily account spending limit in whole US dollars - Leave at 0 for no limit"
  type        = number
  default     = 0
}

variable "daily_budget_emails" {
  description = "List of email addresses to notify if daily budget exceeded"
  type        = list(string)
  default     = []
}