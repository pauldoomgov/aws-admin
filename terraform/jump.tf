# set up cross account access on the jump account side

# allow assuming admin role into all accounts in the organization
data "aws_iam_policy_document" "cross_account" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [for acct in data.aws_organizations_organization.main.accounts : "arn:aws:iam::${acct.id}:role/${var.role_name}"]
  }
}

resource "aws_iam_policy" "assume_role" {
  name   = "allow-assume-cross-account-role"
  policy = data.aws_iam_policy_document.cross_account.json
}

resource "aws_iam_group_policy_attachment" "assume_role" {
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.assume_role.arn
}
