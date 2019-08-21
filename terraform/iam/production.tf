#devops

#Readonly Access Role
resource "aws_iam_policy_attachment" "ReadOnlyAccess_attach" {
  count      = "${var.is_production}"
  name       = "ReadOnlyAccess_attachment"
  groups     = ["${aws_iam_group.securityAssessment_group.name}", "${aws_iam_group.securityOperations_group.name}", "${aws_iam_group.devsecops_group.name}", "${aws_iam_group.incidentResponse_group.name}"]
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}

resource "aws_iam_group_policy_attachment" "tts_default_mfa_prod_attach" {
  count      = "${var.is_production}"
  group      = "${aws_iam_group.default_group.name}"
  policy_arn = "${aws_iam_policy.tts_mfa.arn}"
}

resource "aws_iam_group_policy_attachment" "tts_default_remote_prod_attach" {
  count      = "${var.is_production}"
  group      = "${aws_iam_group.default_group.name}"
  policy_arn = "${aws_iam_policy.tts_remoteAccess_policy.arn}"
}


resource "aws_iam_policy" "tts_management_assume_org_account_access_role" {
  count       = "${var.is_production}"
  name        = "tts-management-assumeOrgAccountAccessRole"
  description = "Allow access to assume role for view only access to billing and usage"

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {
         "Effect":"Allow",
         "Action":[  
            "sts:AssumeRole"
         ],
         "Resource":["arn:aws:iam::*:role/OrganizationAccountAccessRole"]
      }
   ]
}
EOF
}
