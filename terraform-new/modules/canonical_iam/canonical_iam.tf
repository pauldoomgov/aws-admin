# Build the IAM statement containing all the accounts for which sts:assumerole will be allowed (for administrators)
data "aws_iam_policy_document" "tech-portfolio-cross-account-policy" {
  statement {
    sid                       = "TechPortfolioCrossAccountPolicy"
    effect                    = "Allow"

    actions                   = [
      "sts:AssumeRole"
    ]

    resources                 = [
      for aid in var.tech_portfolio_managed_accts :
      "arn:aws:iam::${aid}:role/${var.cross_account_admin_role}"
    ]
  }
}

# Create the IAM policy allowing cross account access
resource "aws_iam_policy" "allow-assume-cross-account-policy" {
  name                    = "allow-assume-cross-account-policy"
  path                    = "/"
  description             = "Policy used by canonical user administrators for cross-account administrator access in managed accounts"

  policy                  = data.aws_iam_policy_document.tech-portfolio-cross-account-policy.json
}

# Create group for tech portfolio admins
resource "aws_iam_group" "tts-tech-portfolio-administrators" {
  name                    = "tts-tech-portfolio-administrators"
  path                    = "/"
}

# Attach the appropriate policies to the tech portfolio admin group
resource "aws_iam_group_policy_attachment" "tts-tech-portfolio-administrators-policies" {
  group                   = aws_iam_group.tts-tech-portfolio-administrators.name
  policy_arn              = aws_iam_policy.allow-assume-cross-account-policy.arn
}

# Attach the AdministratorAccess policy
resource "aws_iam_group_policy_attachment" "administratoraccess" {
  group                   = aws_iam_group.tts-tech-portfolio-administrators.name
  policy_arn              = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create administrators
#resource "aws_iam_user" "tech-portfolio-administrators" {
#  for_each                = "${var.canonical_admins}"
#
#  name                    = "${each.key}@${var.account_suffix}"
#  path                    = "/"
#}

# Add administrators to tech portfolio admin groups
#resource "aws_iam_group_membership" "tts-tech-portfolio-administrators" {
#  for_each aws_iam_user.tech-portfolio-administrators
#  name                    = "tts-tech-portfolio-administrators"
#
#  users                   = var.canonical_admins
#  group
#
#  users                   = [
#    for user in var.canonical_admins :
#  ]
#}
