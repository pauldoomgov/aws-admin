data "aws_organizations_organization" "main" {}

resource "aws_organizations_organizational_unit" "bu" {
  name      = var.name
  parent_id = data.aws_organizations_organization.main.roots.0.id
}

data "aws_ssm_parameter" "monthly_limit" {
  name = "/tts/aws-budget/${var.budget_param_name}"
}

locals {
  tech_portfolio_email = "devops@gsa.gov"
}

resource "aws_budgets_budget" "bu" {
  name = var.name

  budget_type = "COST"
  limit_unit  = "USD"
  # for some reason it adds a single decimal
  limit_amount      = "${data.aws_ssm_parameter.monthly_limit.value}.0"
  time_period_start = "2019-11-07_00:00"
  time_unit         = "MONTHLY"

  cost_filters = {
    CostCategory = join("$", ["Business Units", coalesce(var.cost_category_name, var.name)])
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 95
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [local.tech_portfolio_email, var.email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [local.tech_portfolio_email, var.email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 95
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [local.tech_portfolio_email, var.email]
  }
}
