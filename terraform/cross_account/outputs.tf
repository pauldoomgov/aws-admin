output "switch_role_urls" {
  value = { for acct in var.dest_account_numbers : "${acct}" => "https://signin.aws.amazon.com/switchrole?roleName=${var.role_name}&account=${acct}&displayName=${acct}" }
}
