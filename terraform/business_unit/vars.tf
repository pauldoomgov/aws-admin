variable "name" {
  type = string
}

variable "budget_param_name" {
  type        = string
  description = "Name of the AWS Systems Manager Parameter Store budget, excluding the path"
}

variable "cost_category_name" {
  type        = string
  default     = null
  description = "The rule within the Business Units cost category. Defaults to the name."
}

variable "email" {
  type = string
}
