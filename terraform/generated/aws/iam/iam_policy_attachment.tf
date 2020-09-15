resource "aws_iam_policy_attachment" "tfer--Cognito-002D-1567615384638" {
  name       = "Cognito-1567615384638"
  policy_arn = "arn:aws:iam::133032889584:policy/service-role/Cognito-1567615384638"
  roles      = ["TTSAWSadmins-SMS-Role"]
}

resource "aws_iam_policy_attachment" "tfer--IAM-002D-ManageOwnAccessKeys" {
  groups     = ["IAM-ManageOwnAccessKeys"]
  name       = "IAM-ManageOwnAccessKeys"
  policy_arn = "arn:aws:iam::133032889584:policy/IAM-ManageOwnAccessKeys"
}

resource "aws_iam_policy_attachment" "tfer--IAM-002D-ManageOwnMFA" {
  groups     = ["IAM-ManageOwnMFA"]
  name       = "IAM-ManageOwnMFA"
  policy_arn = "arn:aws:iam::133032889584:policy/IAM-ManageOwnMFA"
}

resource "aws_iam_policy_attachment" "tfer--allow-002D-assume-002D-cross-002D-account-002D-role" {
  groups     = ["tts-tech-portfolio-admins"]
  name       = "allow-assume-cross-account-role"
  policy_arn = "arn:aws:iam::133032889584:policy/allow-assume-cross-account-role"
}
