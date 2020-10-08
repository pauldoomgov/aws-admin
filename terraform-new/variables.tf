# Universal tts cross account admin role
variable "tts_portfolio_cross_account_admin" {
  type    = string
  default = "CrossAccountAdmin"
}

# Universal tts securityaudit role
variable "tts_portfolio_securityaudit_role" {
  type    = string
  default = "tts_securityaudit_role"
}

# Master AWS account ID
variable "tts_master_account_id" {
  type    = string
  default = "133032889584"
}

# List of accounts managed by tts
variable "tts_managed_accounts" {
  type    = list(string)
  default = ["570696747145"]
}

# Primary region
variable "region" {
	type		=	string
	default	=	"us-west-2"
}

variable "state_control_prefix" {
	type		=	string
	default	=	"tts-terraform"
}
