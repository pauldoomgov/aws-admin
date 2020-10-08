provider "aws" {
}

data "aws_caller_identity" "current" {
}

locals {
  cloudtrail_trail_name       = "tts-tech-portfolio-cloudtrail"
  cloudtrail_bucket_name      = "${local.cloudtrail_trail_name}-${data.aws_caller_identity.current.account_id}"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Create S3 bucket to hold cloudtrail data
resource "aws_s3_bucket" "tts-tech-portfolio-s3" {
  bucket                      = local.cloudtrail_bucket_name

  policy                      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.cloudtrail_bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.cloudtrail_bucket_name}/CloudTrail/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

# Create account cloudtrail
resource "aws_cloudtrail" "tts-tech-portfolio-cloudtrail" {
  name                          = local.cloudtrail_trail_name
  s3_bucket_name                = local.cloudtrail_bucket_name
  s3_key_prefix                 = "CloudTrail"

  include_global_service_events = true
  is_multi_region_trail         = true

  enable_logging                = var.enable_tts_cloudtrail
}
