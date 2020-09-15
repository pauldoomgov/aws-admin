resource "aws_iam_policy" "tfer--Cognito-002D-1567615384638" {
  name = "Cognito-1567615384638"
  path = "/service-role/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "sns:publish"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_policy" "tfer--IAM-002D-ManageOwnAccessKeys" {
  name = "IAM-ManageOwnAccessKeys"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "iam:*LoginProfile",
        "iam:*AccessKey*",
        "iam:*SigningCertificate*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::133032889584:user/${aws:username}"
      ],
      "Sid": "AllowUsersAllActionsForCredentials"
    },
    {
      "Action": [
        "iam:*LoginProfile",
        "iam:*AccessKey*",
        "iam:*SigningCertificate*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::133032889584:user/${aws:username}"
      ],
      "Sid": "AllowUsersAllActionsForCredentials"
    },
    {
      "Action": [
        "iam:GetAccount*",
        "iam:ListAccount*"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Sid": "AllowUsersToSeeStatsOnIAMConsoleDashboard"
    },
    {
      "Action": [
        "iam:ListUsers"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::133032889584:user/*"
      ],
      "Sid": "AllowUsersToListUsersInConsole"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_policy" "tfer--IAM-002D-ManageOwnMFA" {
  name = "IAM-ManageOwnMFA"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "iam:*VirtualMFADevice"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::133032889584:mfa/${aws:username}"
      ],
      "Sid": "AllowUsersToCreateDeleteTheirOwnVirtualMFADevices"
    },
    {
      "Action": [
        "iam:*MFADevice*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::133032889584:user/${aws:username}"
      ],
      "Sid": "AllowUsersToEnableSyncDisableTheirOwnMFADevices"
    },
    {
      "Action": [
        "iam:ListVirtualMFADevices"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::133032889584:mfa/*"
      ],
      "Sid": "AllowUsersToListVirtualMFADevices"
    },
    {
      "Action": [
        "iam:ListUsers"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::133032889584:user/*"
      ],
      "Sid": "AllowUsersToListUsersInConsole"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_policy" "tfer--allow-002D-assume-002D-cross-002D-account-002D-role" {
  name = "allow-assume-cross-account-role"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::960119293461:role/CrossAccountAdmin",
        "arn:aws:iam::894947205914:role/CrossAccountAdmin",
        "arn:aws:iam::821341638715:role/CrossAccountAdmin",
        "arn:aws:iam::810504390172:role/CrossAccountAdmin",
        "arn:aws:iam::765358534566:role/CrossAccountAdmin",
        "arn:aws:iam::756406097870:role/CrossAccountAdmin",
        "arn:aws:iam::708694795332:role/CrossAccountAdmin",
        "arn:aws:iam::699351240001:role/CrossAccountAdmin",
        "arn:aws:iam::587807691409:role/CrossAccountAdmin",
        "arn:aws:iam::570696747145:role/CrossAccountAdmin",
        "arn:aws:iam::560284223511:role/CrossAccountAdmin",
        "arn:aws:iam::559685638163:role/CrossAccountAdmin",
        "arn:aws:iam::555546682965:role/CrossAccountAdmin",
        "arn:aws:iam::541873662368:role/CrossAccountAdmin",
        "arn:aws:iam::533787958253:role/CrossAccountAdmin",
        "arn:aws:iam::461353137281:role/CrossAccountAdmin",
        "arn:aws:iam::447901181022:role/CrossAccountAdmin",
        "arn:aws:iam::340731855345:role/CrossAccountAdmin",
        "arn:aws:iam::312530187933:role/CrossAccountAdmin",
        "arn:aws:iam::217680906704:role/CrossAccountAdmin",
        "arn:aws:iam::213305845712:role/CrossAccountAdmin",
        "arn:aws:iam::195022191070:role/CrossAccountAdmin",
        "arn:aws:iam::144433228153:role/CrossAccountAdmin",
        "arn:aws:iam::138431511372:role/CrossAccountAdmin",
        "arn:aws:iam::133032889584:role/CrossAccountAdmin",
        "arn:aws:iam::096224847349:role/CrossAccountAdmin",
        "arn:aws:iam::034795980528:role/CrossAccountAdmin",
        "arn:aws:iam::025697984663:role/CrossAccountAdmin",
        "arn:aws:iam::001907687576:role/CrossAccountAdmin"
      ],
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}
