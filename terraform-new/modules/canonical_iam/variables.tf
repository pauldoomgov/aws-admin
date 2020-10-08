variable "canonical_admins" {
  description = "List of users who are administrators of the canonical account"
  type        = list(string)
#  default     = [ "aidan.feldman", "alyssa.feola", "amit.freeman", "john.jediny" ]
  default     = [ "afreeman.test" ]
}

variable "cross_account_admin_role" {
  description = "Role used for cross account administrator access"
  type        = string
  default     = "CrossAccountAdmin"
}

variable "canonical_admin_groups" {
  description = "Groups attached to canonical account administrators"
  type        = list(string)
  default     = [ "tts-tech-portfolio-administrators", "AdministratorAccess" ]
}

variable "account_suffix" {
  description = "Suffix appended to all users"
  type        = string
  default     = "@gsa.gov"
}

variable "tech_portfolio_managed_accts" {
  description = "List of AWS account ids managed by tech portfolio, for use in policies allowing crossaccountadmin role assumption"
  type        = list(string)
  default     = [ "960119293461", "894947205914", "821341638715", "810504390172", "765358534566", "756406097870", "708694795332", "699351240001", "587807691409", "570696747145", "560284223511", "559685638163", "555546682965", "541873662368", "533787958253", "461353137281", "447901181022", "340731855345", "312530187933", "217680906704", "213305845712", "195022191070", "144433228153", "138431511372", "133032889584", "096224847349", "034795980528", "025697984663", "001907687576" ]
}
