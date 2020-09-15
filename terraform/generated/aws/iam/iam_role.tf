resource "aws_iam_role" "tfer--001907687576-002D-CrossAccountAdmin" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Condition": {},
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::001907687576:root"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Admin assumeRole for 001907687576@gsa.gov"
  max_session_duration = "3600"
  name                 = "001907687576-CrossAccountAdmin"
  path                 = "/"
}

resource "aws_iam_role" "tfer--AWSServiceRoleForAmazonGuardDuty" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "guardduty.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "A service-linked role required for Amazon GuardDuty to access your resources. "
  max_session_duration = "3600"
  name                 = "AWSServiceRoleForAmazonGuardDuty"
  path                 = "/aws-service-role/guardduty.amazonaws.com/"
}

resource "aws_iam_role" "tfer--AWSServiceRoleForElasticLoadBalancing" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticloadbalancing.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows ELB to call AWS services on your behalf."
  max_session_duration = "3600"
  name                 = "AWSServiceRoleForElasticLoadBalancing"
  path                 = "/aws-service-role/elasticloadbalancing.amazonaws.com/"
}

resource "aws_iam_role" "tfer--AWSServiceRoleForOrganizations" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "organizations.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Service-linked role used by AWS Organizations to enable integration of other AWS services with Organizations."
  max_session_duration = "3600"
  name                 = "AWSServiceRoleForOrganizations"
  path                 = "/aws-service-role/organizations.amazonaws.com/"
}

resource "aws_iam_role" "tfer--AWSServiceRoleForSupport" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "support.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Enables resource access for AWS to provide billing, administrative and support services"
  max_session_duration = "3600"
  name                 = "AWSServiceRoleForSupport"
  path                 = "/aws-service-role/support.amazonaws.com/"
}

resource "aws_iam_role" "tfer--AWSServiceRoleForTrustedAdvisor" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "trustedadvisor.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Access for the AWS Trusted Advisor Service to help reduce cost, increase performance, and improve security of your AWS environment."
  max_session_duration = "3600"
  name                 = "AWSServiceRoleForTrustedAdvisor"
  path                 = "/aws-service-role/trustedadvisor.amazonaws.com/"
}

resource "aws_iam_role" "tfer--CrossManagement" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::570696747145:root"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "18F Cross-Account Management Role. "
  max_session_duration = "3600"
  name                 = "CrossManagement"
  path                 = "/"
}

resource "aws_iam_role" "tfer--TTSAWSadmins-002D-SMS-002D-Role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "4a4d4b81-7127-47c6-8149-cc5b35c10be1"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Service": "cognito-idp.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  max_session_duration = "3600"
  name                 = "TTSAWSadmins-SMS-Role"
  path                 = "/service-role/"
}

resource "aws_iam_role" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "CC-583498B7137E07A6B9AC5A6D03E2FB02"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::587807691409:root"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  max_session_duration = "3600"
  name                 = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
  path                 = "/"
}

resource "aws_iam_role" "tfer--securityaudit2" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::133032889584:root"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  max_session_duration = "3600"
  name                 = "securityaudit2"
  path                 = "/"
}
