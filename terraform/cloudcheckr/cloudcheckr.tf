resource "aws_iam_role" "cc_role" {
  count = "${var.enable ? 1 : 0}"
  name  = "tts-cloudcheckr"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::${var.account_id}:root"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
            "StringEquals": {
                "sts:ExternalId": "${var.external_id}"
            }
        }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "inventory_attach" {
  count = "${var.enable && var.enable_inventory ? 1 : 0}"
  role = "${aws_iam_role.cc_role.name}"
  policy_arn = "${aws_iam_policy.inventory.arn}"
}

resource "aws_iam_policy" "inventory" {
  count = "${var.enable && var.enable_inventory ? 1 : 0}"
  name = "tts-cloudcheckr-inventory"
  description = "Policy to allow CloudCheckr SaaS Permissions to Inventory Resources"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"InventoryAndUtilization",
    "Effect":"Allow",
    "Action":[
      "Organizations:Describe*", 
      "Organizations:List*", 
      "acm:DescribeCertificate", 
      "acm:GetCertificate", 
      "acm:ListCertificates", 
      "autoscaling:Describe*", 
      "cloudformation:DescribeStacks", 
      "cloudformation:GetStackPolicy", 
      "cloudformation:GetTemplate", 
      "cloudformation:ListStackResources", 
      "cloudfront:GetDistributionConfig", 
      "cloudfront:GetStreamingDistributionConfig", 
      "cloudfront:List*", 
      "cloudhsm:Describe*", 
      "cloudhsm:List*", 
      "cloudsearch:Describe*", 
      "cloudtrail:DescribeTrails", 
      "cloudtrail:GetTrailStatus", 
      "cloudwatch:DescribeAlarms", 
      "cloudwatch:GetMetricStatistics", 
      "cloudwatch:ListMetrics", 
      "cognito-identity:ListIdentities", 
      "cognito-identity:ListIdentityPools", 
      "cognito-idp:ListGroups", 
      "cognito-idp:ListIdentityProviders", 
      "cognito-idp:ListUserPools", 
      "cognito-idp:ListUsers", 
      "cognito-idp:ListUsersInGroup", 
      "config:Describe*", 
      "config:DescribeConfigRules", 
      "config:GetComplianceDetailsByConfigRule", 
      "datapipeline:DescribePipelines", 
      "datapipeline:GetPipelineDefinition", 
      "datapipeline:ListPipelines", 
      "directconnect:DescribeConnections", 
      "directconnect:DescribeLocations", 
      "directconnect:DescribeVirtualInterfaces", 
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeTable", 
      "dynamodb:ListTables", 
      "dynamodb:ListTagsOfResource", 
      "ec2:Describe*", 
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeHostReservationOfferings",
      "ec2:DescribeHostReservations",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePlacementGroups",
      "ec2:DescribeRegions",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeReservedInstancesListings",
      "ec2:DescribeReservedInstancesModifications",
      "ec2:DescribeReservedInstancesOfferings",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeTags",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
      "ec2:GetConsoleOutput", 
      "ecs:DescribeClusters", 
      "ecs:DescribeContainerInstances", 
      "ecs:DescribeServices", 
      "ecs:DescribeTaskDefinition", 
      "ecs:DescribeTasks", 
      "ecs:ListClusters", 
      "ecs:ListContainerInstances", 
      "ecs:ListServices", 
      "ecs:ListTaskDefinitions", 
      "ecs:ListTasks", 
      "elasticache:Describe*", 
      "elasticache:DescribeReservedCacheNodes",
      "elasticache:DescribeReservedCacheNodesOfferings",
      "elasticache:List*", 
      "elasticbeanstalk:Describe*", 
      "elasticfilesystem:DescribeFileSystems", 
      "elasticfilesystem:DescribeTags", 
      "elasticloadbalancing:Describe*", 
      "elasticmapreduce:Describe*", 
      "elasticmapreduce:List*", 
      "es:DescribeElasticsearchDomains", 
      "es:ListDomainNames", 
      "glacier:DescribeJob", 
      "glacier:DescribeVault", 
      "glacier:GetJobOutput", 
      "glacier:GetVaultNotifications", 
      "glacier:ListJobs", 
      "glacier:ListTagsForVault", 
      "glacier:ListVaults", 
      "iam:GenerateCredentialReport", 
      "iam:Get*", 
      "iam:GetAccountAuthorizationDetails",
      "iam:List*", 
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iot:DescribeThing", 
      "iot:ListThings", 
      "kinesis:DescribeStream", 
      "kinesis:GetShardIterator", 
      "kinesis:ListStreams", 
      "kms:DescribeKey", 
      "kms:GetKeyPolicy", 
      "kms:GetKeyRotationStatus", 
      "kms:ListAliases", 
      "kms:ListGrants", 
      "kms:ListKeyPolicies", 
      "kms:ListKeys", 
      "kms:ListResourceTags", 
      "lambda:ListFunctions", 
      "lambda:ListTags", 
      "rds:Describe*", 
      "rds:DescribeDBInstances",
      "rds:DescribeReservedDBInstances",
      "rds:DescribeReservedDBInstancesOfferings",
      "rds:List*", 
      "redshift:Describe*", 
      "redshift:DescribeReservedNodeOfferings",
      "redshift:DescribeReservedNodes",
      "route53:ListHealthChecks", 
      "route53:ListHostedZones", 
      "route53:ListResourceRecordSets", 
      "s3:GetBucketACL",
      "s3:GetBucketACL", 
      "s3:GetBucketLocation",
      "s3:GetBucketLocation", 
      "s3:GetBucketLogging",
      "s3:GetBucketLogging", 
      "s3:GetBucketNotification",
      "s3:GetBucketNotification", 
      "s3:GetBucketPolicy",
      "s3:GetBucketPolicy", 
      "s3:GetBucketTagging",
      "s3:GetBucketTagging", 
      "s3:GetBucketWebsite",
      "s3:GetBucketWebsite", 
      "s3:GetEncryptionConfiguration", 
      "s3:GetLifecycleConfiguration",
      "s3:GetLifecycleConfiguration", 
      "s3:GetNotificationConfiguration",
      "s3:GetNotificationConfiguration", 
      "s3:List*",
      "s3:List*", 
      "sdb:DomainMetadata", 
      "sdb:ListDomains", 
      "ses:GetIdentityDkimAttributes", 
      "ses:GetIdentityVerificationAttributes", 
      "ses:GetSendQuota", 
      "ses:GetSendStatistics", 
      "ses:ListIdentities", 
      "sns:GetSnsTopic", 
      "sns:GetSubscriptionAttributes", 
      "sns:GetTopicAttributes", 
      "sns:ListSubscriptionsByTopic", 
      "sns:ListTopics", 
      "sqs:GetQueueAttributes", 
      "sqs:ListQueues", 
      "ssm:ListAssociations", 
      "ssm:ListDocumentVersions", 
      "ssm:ListDocuments", 
      "ssm:ListInstanceAssociations", 
      "ssm:ListInventoryEntries", 
      "ssm:ListResourceDataSync", 
      "storagegateway:Describe*", 
      "storagegateway:List*", 
      "support:*", 
      "swf:ListActivityTypes", 
      "swf:ListClosedWorkflowExecutions", 
      "swf:ListDomains", 
      "swf:ListWorkflowTypes", 
      "workspaces:DescribeWorkspaceBundles", 
      "workspaces:DescribeWorkspaceDirectories", 
      "workspaces:DescribeWorkspaces"
    ],
    "Resource":"*"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "security_attach" {
  count      = "${var.enable && var.enable_security ? 1 : 0}"
  role       = "${aws_iam_role.cc_role.name}"
  policy_arn = "${aws_iam_policy.security.arn}"
}

resource "aws_iam_policy" "security" {
  count       = "${var.enable && var.enable_security ? 1 : 0}"
  name        = "tts-cloudcheckr-security"
  description = "Policy to allow CloudCheckr SaaS Permissions to Security"

  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[{
        "Sid": "SecurityPermissons",
        "Effect":"Allow",
        "Action":[
                "acm:DescribeCertificate",
                "acm:GetCertificate",
                "acm:ListCertificates",
                "cloudtrail:DescribeTrails",
                "cloudtrail:GetTrailStatus",
                "config:DescribeConfigRules",
                "config:DescribeConfigurationRecorderStatus",
                "config:DescribeConfigurationRecorders",
                "config:DescribeDeliveryChannelStatus",
                "config:DescribeDeliveryChannels",
                "config:GetComplianceDetailsByConfigRule",
                "ec2:Describe*",
                "iam:GenerateCredentialReport",
                "iam:Get*",
                "iam:List*",
                "kms:DescribeKey",
                "kms:GetKeyPolicy",
                "kms:GetKeyRotationStatus",
                "kms:ListAliases",
                "kms:ListGrants",
                "kms:ListKeyPolicies",
                "kms:ListKeys",
                "kms:ListResourceTags",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "rds:Describe*",
                "ses:GetIdentityDkimAttributes",
                "ses:GetIdentityVerificationAttributes",
                "ses:GetSendQuota",
                "ses:GetSendStatistics",
                "ses:ListIdentities",
                "sns:GetSnsTopic",
                "sns:GetSubscriptionAttributes",
                "sns:GetTopicAttributes",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "sqs:GetQueueAttributes",
                "sqs:ListQueues"
            ],
        "Resource": "*"
    }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  count = "${var.enable && var.enable_cloudwatch ? 1 : 0}"
  role = "${aws_iam_role.cc_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch.arn}"
}

resource "aws_iam_policy" "cloudwatch" {
  count = "${var.enable && var.enable_cloudwatch ? 1 : 0}"
  name = "tts-cloudcheckr-cloudwatch"
  description = "Policy to allow CloudCheckr SaaS Permissions to CloudWatch Flow Logs"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"CloudWatchLogsSpecific",
    "Effect":"Allow",
    "Action":[
      "logs:GetLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ],
    "Resource":[
      "arn:aws:logs:*:*:*"
    ]
  }]
}
EOF
}

resource "aws_iam_policy" "cloudtrail" {
  count       = "${var.enable && length(var.cloudtrail_bucket) > 0 ? 1 : 0}"
  name        = "tts-cloudcheckr-cloudtrail"
  description = "Policy to allow CloudCheckr SaaS Permissions to CloudTrail Bucket"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{  
    "Sid":"CloudTrailPermissions",
    "Effect":"Allow",
    "Action":[  
        "s3:GetBucketACL",
        "s3:GetBucketLocation",
        "s3:GetBucketLogging",
        "s3:GetBucketPolicy",
        "s3:GetBucketTagging",
        "s3:GetBucketWebsite",
        "s3:GetBucketNotification",
        "s3:GetLifecycleConfiguration",
        "s3:GetNotificationConfiguration",
        "s3:GetObject",
        "s3:List*"
    ],
    "Resource":[
        "arn:aws:s3:::${var.cloudtrail_bucket}",
        "arn:aws:s3:::${var.cloudtrail_bucket}/*"
    ]
  }]
}
EOF
}
