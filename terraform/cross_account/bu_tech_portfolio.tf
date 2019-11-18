resource "aws_organizations_organizational_unit" "tts" {
  provider  = aws.payer
  name      = "TTS Tech Portfolio"
  parent_id = "${data.aws_organizations_organization.main.roots.0.id}"
}

locals {
  tech_portfolio_email = "devops@gsa.gov"
}

resource "aws_budgets_budget" "tts" {
  provider = aws.payer

  name = "TTS Tech Portfolio"

  budget_type       = "COST"
  limit_unit        = "USD"
  limit_amount      = "2000.0"
  time_period_start = "2019-11-07_00:00"
  time_unit         = "MONTHLY"

  cost_filters = {
    # https://github.com/terraform-providers/terraform-provider-aws/issues/5890#issuecomment-485600055
    LinkedAccount = join(",", [for acct in aws_organizations_organizational_unit.tts.accounts : acct.id])
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 95
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [local.tech_portfolio_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [local.tech_portfolio_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 95
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [local.tech_portfolio_email]
  }
}
