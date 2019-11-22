output "switch_role_urls" {
  value = { for acct in data.aws_organizations_organization.main.accounts : "${acct.id}" => "https://signin.aws.amazon.com/switchrole?roleName=${var.role_name}&account=${acct.id}&displayName=${acct.id}" }
}
