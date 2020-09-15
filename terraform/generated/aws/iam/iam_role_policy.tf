resource "aws_iam_role_policy" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ_CloudCheckr-002D-CUR-002D-Policy" {
  name = "CloudCheckr-CUR-Policy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::TTS-Shared-Usage",
        "arn:aws:s3:::TTS-Shared-Usage/*"
      ],
      "Sid": "CostReadCUR"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  role = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
}

resource "aws_iam_role_policy" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ_CloudCheckr-002D-CloudTrail-002D-Policy" {
  name = "CloudCheckr-CloudTrail-Policy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "s3:GetBucketACL",
        "s3:GetBucketLocation",
        "s3:GetBucketLogging",
        "s3:GetBucketPolicy",
        "s3:GetBucketTagging",
        "s3:GetBucketWebsite",
        "s3:GetBucketNotification",
        "s3:GetLifecycleConfiguration",
        "s3:GetObject",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::TTS-Shared-Cloudtrail",
        "arn:aws:s3:::TTS-Shared-Cloudtrail/*"
      ],
      "Sid": "CloudTrailPermissions"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  role = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
}

resource "aws_iam_role_policy" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ_CloudCheckr-002D-CloudWatchFlowLogs-002D-Policy" {
  name = "CloudCheckr-CloudWatchFlowLogs-Policy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "logs:GetLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:*:*:*"
      ],
      "Sid": "CloudWatchLogsSpecific"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  role = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
}

resource "aws_iam_role_policy" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ_CloudCheckr-002D-Cost-002D-Policy" {
  name = "CloudCheckr-Cost-Policy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeReservedInstancesOfferings",
        "ec2:DescribeReservedInstances",
        "ec2:DescribeReservedInstancesListings",
        "ec2:DescribeHostReservationOfferings",
        "ec2:DescribeReservedInstancesModifications",
        "ec2:DescribeHostReservations",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeKeyPairs",
        "ec2:DescribePlacementGroups",
        "ec2:DescribeAddresses",
        "ec2:DescribeSpotInstanceRequests",
        "ec2:DescribeImages",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeSnapshots",
        "ec2:DescribeVolumes",
        "ec2:DescribeTags",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeVolumeStatus",
        "elasticache:DescribeReservedCacheNodes",
        "elasticache:DescribeReservedCacheNodesOfferings",
        "rds:DescribeReservedDBInstances",
        "rds:DescribeReservedDBInstancesOfferings",
        "rds:DescribeDBInstances",
        "redshift:DescribeReservedNodes",
        "redshift:DescribeReservedNodeOfferings",
        "s3:GetBucketACL",
        "s3:GetBucketLocation",
        "s3:GetBucketLogging",
        "s3:GetBucketPolicy",
        "s3:GetBucketTagging",
        "s3:GetBucketWebsite",
        "s3:GetBucketNotification",
        "s3:GetLifecycleConfiguration",
        "s3:List*",
        "dynamodb:DescribeReservedCapacity",
        "dynamodb:DescribeReservedCapacityOfferings",
        "iam:GetAccountAuthorizationDetails",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "CloudCheckrCostPermissions"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  role = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
}

resource "aws_iam_role_policy" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ_CloudCheckr-002D-DBR-002D-Policy" {
  name = "CloudCheckr-DBR-Policy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "s3:GetBucketACL",
        "s3:GetBucketLocation",
        "s3:GetBucketLogging",
        "s3:GetBucketPolicy",
        "s3:GetBucketTagging",
        "s3:GetBucketWebsite",
        "s3:GetBucketNotification",
        "s3:GetLifecycleConfiguration",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::TTS-Shared-Billing",
        "arn:aws:s3:::TTS-Shared-Billing/*"
      ],
      "Sid": "CostReadDBR"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  role = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
}

resource "aws_iam_role_policy" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ_CloudCheckr-002D-Inventory-002D-Policy" {
  name = "CloudCheckr-Inventory-Policy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate",
        "ec2:Describe*",
        "ec2:GetConsoleOutput",
        "autoscaling:Describe*",
        "cloudformation:DescribeStacks",
        "cloudformation:GetStackPolicy",
        "cloudformation:GetTemplate",
        "cloudformation:ListStackResources",
        "cloudfront:List*",
        "cloudfront:GetDistributionConfig",
        "cloudfront:GetStreamingDistributionConfig",
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
        "config:DescribeConfigRules",
        "config:GetComplianceDetailsByConfigRule",
        "config:Describe*",
        "datapipeline:ListPipelines",
        "datapipeline:GetPipelineDefinition",
        "datapipeline:DescribePipelines",
        "directconnect:DescribeLocations",
        "directconnect:DescribeConnections",
        "directconnect:DescribeVirtualInterfaces",
        "dynamodb:ListTables",
        "dynamodb:DescribeTable",
        "dynamodb:ListTagsOfResource",
        "ecs:ListClusters",
        "ecs:DescribeClusters",
        "ecs:ListContainerInstances",
        "ecs:DescribeContainerInstances",
        "ecs:ListServices",
        "ecs:DescribeServices",
        "ecs:ListTaskDefinitions",
        "ecs:DescribeTaskDefinition",
        "ecs:ListTasks",
        "ecs:DescribeTasks",
        "ssm:ListResourceDataSync",
        "ssm:ListAssociations",
        "ssm:ListDocumentVersions",
        "ssm:ListDocuments",
        "ssm:ListInstanceAssociations",
        "ssm:ListInventoryEntries",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticbeanstalk:Describe*",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeTags",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:Describe*",
        "elasticmapreduce:List*",
        "es:ListDomainNames",
        "es:DescribeElasticsearchDomains",
        "glacier:ListTagsForVault",
        "glacier:DescribeVault",
        "glacier:GetVaultNotifications",
        "glacier:DescribeJob",
        "glacier:GetJobOutput",
        "glacier:ListJobs",
        "glacier:ListVaults",
        "iam:Get*",
        "iam:List*",
        "iam:GenerateCredentialReport",
        "iot:DescribeThing",
        "iot:ListThings",
        "kms:DescribeKey",
        "kms:GetKeyPolicy",
        "kms:GetKeyRotationStatus",
        "kms:ListAliases",
        "kms:ListGrants",
        "kms:ListKeys",
        "kms:ListKeyPolicies",
        "kms:ListResourceTags",
        "kinesis:ListStreams",
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "lambda:ListFunctions",
        "lambda:ListTags",
        "Organizations:List*",
        "Organizations:Describe*",
        "rds:Describe*",
        "rds:List*",
        "redshift:Describe*",
        "route53:ListHealthChecks",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "s3:GetBucketACL",
        "s3:GetBucketLocation",
        "s3:GetBucketLogging",
        "s3:GetBucketPolicy",
        "s3:GetBucketTagging",
        "s3:GetBucketWebsite",
        "s3:GetBucketNotification",
        "s3:GetLifecycleConfiguration",
        "s3:List*",
        "sdb:ListDomains",
        "sdb:DomainMetadata",
        "ses:ListIdentities",
        "ses:GetSendStatistics",
        "ses:GetIdentityDkimAttributes",
        "ses:GetIdentityVerificationAttributes",
        "ses:GetSendQuota",
        "sns:GetTopicAttributes",
        "sns:GetSubscriptionAttributes",
        "sns:ListTopics",
        "sns:ListSubscriptionsByTopic",
        "sqs:ListQueues",
        "sqs:GetQueueAttributes",
        "storagegateway:Describe*",
        "storagegateway:List*",
        "support:*",
        "swf:ListClosedWorkflowExecutions",
        "swf:ListDomains",
        "swf:ListActivityTypes",
        "swf:ListWorkflowTypes",
        "workspaces:DescribeWorkspaceDirectories",
        "workspaces:DescribeWorkspaceBundles",
        "workspaces:DescribeWorkspaces"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "InventoryAndUtilization"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  role = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
}

resource "aws_iam_role_policy" "tfer--cloudcheckr-002D-standard-002D-user-002D-IamRole-002D-8JPNNXHQOWSZ_CloudCheckr-002D-Security-002D-Policy" {
  name = "CloudCheckr-Security-Policy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "logs:GetLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "config:DescribeConfigRules",
        "config:GetComplianceDetailsByConfigRule",
        "config:DescribeDeliveryChannels",
        "config:DescribeDeliveryChannelStatus",
        "config:DescribeConfigurationRecorders",
        "config:DescribeConfigurationRecorderStatus",
        "ec2:Describe*",
        "iam:Get*",
        "iam:List*",
        "iam:GenerateCredentialReport",
        "kms:DescribeKey",
        "kms:GetKeyPolicy",
        "kms:GetKeyRotationStatus",
        "kms:ListAliases",
        "kms:ListGrants",
        "kms:ListKeys",
        "kms:ListKeyPolicies",
        "kms:ListResourceTags",
        "rds:Describe*",
        "ses:ListIdentities",
        "ses:GetSendStatistics",
        "ses:GetIdentityDkimAttributes",
        "ses:GetIdentityVerificationAttributes",
        "ses:GetSendQuota",
        "sns:GetTopicAttributes",
        "sns:GetSubscriptionAttributes",
        "sns:ListTopics",
        "sns:ListSubscriptionsByTopic",
        "sqs:ListQueues",
        "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "SecurityPermissons"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  role = "cloudcheckr-standard-user-IamRole-8JPNNXHQOWSZ"
}
