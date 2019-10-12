provider "aws" {
  version = "~> 2.32"
  # account: tts-prod (133032889584)
  region  = "us-east-1"
}

resource "aws_iam_group" "admins" {
  name = "tts-tech-portfolio-admins"
}

resource "aws_iam_policy" "assume_role" {
  name        = "allow-assume-cross-account-role"
  # description = "A test policy"
  policy      = <<JSON
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::144433228153:role/CrossAccountAdmin"
  }
}
JSON
}

resource "aws_iam_group_policy_attachment" "assume_role" {
  group      = "${aws_iam_group.admins.name}"
  policy_arn = "${aws_iam_policy.assume_role.arn}"
}
