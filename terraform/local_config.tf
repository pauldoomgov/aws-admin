provider "local" {
  version = "~> 1.4"
}

resource "local_file" "aws_config" {
  # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-settings
  # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html
  content = <<EOT
[default]
region = us-east-1
%{for account in data.aws_organizations_organization.main.accounts}
[profile ${replace(lower(account.name), "/\\W/", "-")}]
role_arn = arn:aws:iam::${account.id}:role/${var.role_name}
source_profile = default
%{endfor~}
EOT

  filename        = "${path.module}/aws_config.ini"
  file_permission = "0600"
}
