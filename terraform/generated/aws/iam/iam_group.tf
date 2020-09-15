resource "aws_iam_group" "tfer--Administrators" {
  name = "Administrators"
  path = "/"
}

resource "aws_iam_group" "tfer--IAM-002D-ManageOwnAccessKeys" {
  name = "IAM-ManageOwnAccessKeys"
  path = "/"
}

resource "aws_iam_group" "tfer--IAM-002D-ManageOwnMFA" {
  name = "IAM-ManageOwnMFA"
  path = "/"
}

resource "aws_iam_group" "tfer--tts-002D-tech-002D-portfolio-002D-admins" {
  name = "tts-tech-portfolio-admins"
  path = "/"
}
