resource "aws_budgets_budget" "daily_budget" {
  count = var.daily_budget_usd > 0 ? 1 : 0

  name = var.name

  budget_type = "COST"
  limit_unit  = "USD"
  # for some reason it adds a single decimal
  limit_amount      = "${var.daily_budget_usd}.0"
  time_period_start = "2019-11-07_00:00"
  time_unit         = "DAILY"

  cost_filters = {
    LinkedAccount = var.account_id
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.daily_budget_emails
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.daily_budget_emails
  }
}
