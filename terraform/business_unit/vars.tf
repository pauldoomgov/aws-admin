variable "name" {
  type = string
}

variable "budget_param_name" {
  type        = string
  description = "Name of the AWS Systems Manager Parameter Store budget, excluding the path"
}

variable "email" {
  type = string
}
