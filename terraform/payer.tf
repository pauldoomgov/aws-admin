# for viewing billing across the AWS Organization
resource "aws_iam_group" "tenant_biller" {
  provider = aws.payer

  name = "TenantBiller"
}

resource "aws_iam_group_policy_attachment" "tenant_biller" {
  provider = aws.payer

  group      = aws_iam_group.org_wide_billing.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}
