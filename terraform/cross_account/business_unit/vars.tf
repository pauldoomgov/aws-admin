variable "name" {
  type = "string"
}

variable "email" {
  type = "string"
}

variable "monthly_limit" {
  type        = number
  description = "The budget amount, in dollars"
}
