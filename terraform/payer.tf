# for viewing billing across the AWS Organization
resource "aws_iam_group" "org_wide_billing" {
  provider = aws.payer

  name = "TenantBilling"
}

resource "aws_iam_group_policy_attachment" "org_wide_billing" {
  provider = aws.payer

  group      = aws_iam_group.org_wide_billing.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}
