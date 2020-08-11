provider "local" {
  version = "~> 1.4"
}

resource "local_file" "aws_config" {
  content         = templatefile("${path.module}/aws_config.ini.tmpl", { accounts = data.aws_organizations_organization.main.accounts, role_name = var.role_name })
  filename        = "${path.module}/aws_config.ini"
  file_permission = "0600"
}
