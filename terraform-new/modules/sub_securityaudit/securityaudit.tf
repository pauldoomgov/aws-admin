provider "aws" {
}

variable "canonical_account_id" {
  type            = string
  default         = "133032889584"
}

resource "aws_iam_role" "tts_securityaudit_role" {
  name            = "tts_securityaudit_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.canonical_account_id}:root"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tts_securityaudit_role" {
  role            = aws_iam_role.tts_securityaudit_role.name
  policy_arn      = "arn:aws:iam::aws:policy/SecurityAudit"
}
