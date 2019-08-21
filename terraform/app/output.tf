output "env" {
  value = "${var.appenv}"
}

output "name" {
  value = "tts-${var.appenv}-core"
}

output "is_production" {
  value = "${var.appenv == "production" ? 1 : 0}"
}

output "is_staging" {
  value = "${var.appenv == "staging" ? 1 : 0}"
}

output "is_test" {
  value = "${var.appenv == "test" ? 1 : 0}"
}

output "is_development" {
  value = "${var.appenv == "development" ? 1 : 0}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}
