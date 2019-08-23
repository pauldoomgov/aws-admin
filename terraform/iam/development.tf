#devsecops group
resource "aws_iam_group_policy_attachment" "tts_devsecops_dev_attach" {
  count      = "${var.is_development}"
  group      = "${aws_iam_group.devsecops_group.name}"
  policy_arn = "${aws_iam_policy.tts_devsecops_dev_policy.arn}"
}

#default group
resource "aws_iam_group_policy_attachment" "tts_default_mfa_dev_attach" {
  count      = "${var.is_development}"
  group      = "${aws_iam_group.default_group.name}"
  policy_arn = "${aws_iam_policy.tts_mfa.arn}"
}

#Readonly Access Role
resource "aws_iam_policy_attachment" "ReadOnlyAccess_dev_attach" {
  count      = "${var.is_development}"
  name       = "ReadOnlyAccess_attachment"
  groups     = ["${aws_iam_group.securityAssessment_group.name}", "${aws_iam_group.securityOperations_group.name}", "${aws_iam_group.incidentResponse_group.name}"]
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}

#devops

resource "aws_iam_group_policy_attachment" "tts_devops_dev_attach" {
  count      = "${var.is_development}"
  group      = "${aws_iam_group.devsecops_group.name}"
  policy_arn = "${aws_iam_policy.tts_devops.arn}"
}

#limited poweruser

resource "aws_iam_group_policy_attachment" "Limited_Poweruser" {
  count      = "${var.is_development}"
  group      = "${aws_iam_group.devsecops_group.name}"
  policy_arn = "${aws_iam_policy.tts_Region_Restricted_PowerUserAccess.arn}"
}

resource "aws_iam_role" "tts_devops_role_dev" {
  # use count to exclude resources from a particular environment
  count = "${var.is_development}"
  name  = "tts-${var.env}-devops"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.aws_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#Policy Section #
resource "aws_iam_policy" "tts_devsecops_dev_policy" {
  count = "${var.is_development}"
  name = "tts-${var.env}-devsecops"
  description = "Provides devsecops_dev group the ability to assume custom orgAccountAccess roles in Development environment test tenant accounts"

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {  
         "Sid":"devsecopsDevEnv",
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

#policy for devops
resource "aws_iam_policy" "tts_devops" {
  count       = "${var.is_development}"
  name        = "tts-${var.env}-devops"
  description = "Policy to allow devops to access IAM data "

  policy = <<EOF
{
        "Version":"2012-10-17",
        "Statement":[
        {
        "Effect":"Allow",
            "Action":[  
          "iam:ChangePassword",
          "iam:GetAccountPasswordPolicy",
          "iam:GetGroupPolicy",
          "iam:GetGroup",
          "iam:GetUser",
          "iam:GetUserPolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAccessKeys",
          "iam:ListAccountAliases",
          "iam:ListAttachedGroupPolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListAttachedUserPolicies",
          "iam:ListEntitiesForPolicy",
          "iam:ListGroupPolicies",
          "iam:ListGroups",
          "iam:ListGroupsForUser",
          "iam:ListInstanceProfiles",
          "iam:ListInstanceProfilesForRole",
          "iam:ListPolicies",
          "iam:ListPolicyVersions",
          "iam:ListRolePolicies",
          "iam:ListRoleTags",
          "iam:ListRoles",
          "iam:ListSSHPublicKeys",
          "iam:ListServerCertificates",
          "iam:ListServiceSpecificCredentials",
          "iam:ListSigningCertificates",
          "iam:ListUserPolicies",
          "iam:ListUserTags",
          "iam:ListUsers"
         ],
         "Resource":"*"
          }
     ]
}
EOF
}

# region poweruser restriction
resource "aws_iam_policy" "tts_Region_Restricted_PowerUserAccess" {
  count = "${var.is_development}"
  name = "tts-${var.env}-region-restricted-poweruseraccess"
  description = "limit PowerUserAccess to only us-east-1."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyPowerUserOutsideUS",
      "Effect": "Allow",
      "NotAction": [
        "iam:*",
        "organizations:*"
      ],
      "Resource": "*",
        "Condition": {"StringEquals": {"aws:RequestedRegion": [
            "us-east-1"
        ]}}
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole",
        "iam:DeleteServiceLinkedRole",
        "iam:ListRoles",
        "organizations:DescribeOrganization"
      ],
      "Resource": "*",
        "Condition": {"StringEquals": {"aws:RequestedRegion": [
            "us-east-1"
        ]}}
    }
  ]
}
EOF
}
