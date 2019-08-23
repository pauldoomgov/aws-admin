#Circle CI Deployer
resource "aws_iam_user" "deployer" {
  name = "circle-deployer-${var.env}"
}


# region poweruser restriction for CI Deployer
resource "aws_iam_policy" "tts_Region_Restricted_PowerUserAccess_Deployer" {
  name        = "tts-${var.env}-region-restricted-poweruseraccess-deployer"
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

resource "aws_iam_user_policy" "deployer_org" {
  name = "deployer_org"
  user = "${aws_iam_user.deployer.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:AttachRolePolicy",
        "iam:CreatePolicy",
        "iam:CreatePolicyVersion",
        "iam:CreateRole",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteRole",
        "iam:DetachRolePolicy",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:ListInstanceProfilesForRole",
        "iam:ListPolicyVersions",
        "iam:PassRole",
        "iam:PutRolePolicy",
        "iam:UpdateRoleDescription",
	"iam:AddUserToGroup",
	"iam:AttachGroupPolicy",
	"iam:CreateGroup",
	"iam:DeleteGroup",
	"iam:DeleteGroupPolicy",
	"iam:DetachGroupPolicy",
	"iam:GetGroup",
	"iam:GetGroupPolicy",
	"iam:ListAttachedGroupPolicies",
	"iam:ListGroupPolicies",
	"iam:ListGroups",
	"iam:ListGroupsForUser",
	"iam:PutGroupPolicy",
	"iam:RemoveUserFromGroup",
	"iam:UpdateGroup",
  "iam:UpdateAccountPasswordPolicy",
  "iam:GetAccountPasswordPolicy"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
{  
   "Effect":"Allow",
   "NotAction":[  
      "iam:ChangePassword",
      "iam:CreateAccessKey",
      "iam:DeleteServerCertificate",
      "iam:DeleteVirtualMFADevice",
      "iam:UpdateAccountPasswordPolicy"
   ],
   "Resource":"*"
},
{  
   "Effect":"Allow",
   "Action":[  
      "iam:CreateServiceLinkedRole",
      "iam:DeleteServiceLinkedRole",
      "iam:ListRoles",
      "organizations:DescribeOrganization"
   ],
   "Resource":"*"
}
  ]
}
EOF
}

#IAM password  Policy
resource "aws_iam_account_password_policy" "tts_iam_password_policy" {
  minimum_password_length        = 16
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 10
}

# Create TTS IAM Users and Groups for Production
resource "aws_iam_group" "devsecops_group" {
  name = "devsecops-${var.env}"
}

resource "aws_iam_group" "default_group" {
  name = "default-${var.env}"
}

resource "aws_iam_group" "securityAssessment_group" {
  name = "securityAssessment-${var.env}"
}

resource "aws_iam_group" "securityOperations_group" {
  name = "securityOperations-${var.env}"
}

resource "aws_iam_group" "finance_group" {
  name = "finance-${var.env}"
}

resource "aws_iam_group" "userManagement_group" {
  name = "userManagement-${var.env}"
}

resource "aws_iam_group" "fullAdmin_group" {
  name = "fullAdmin-${var.env}"
}

resource "aws_iam_group" "incidentResponse_group" {
  name = "incidentResponse-${var.env}"
}

##Role Section ##

# tts mgmt billing role

resource "aws_iam_role" "tts_management_billing_role" {
  name = "tts-${var.env}-management-billing"

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

#tts mgmt org admin role
resource "aws_iam_role" "tts_management_orgAdmin_role" {
  name = "tts-${var.env}-management-orgAdmin"

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

#tts mgmt full admin role
resource "aws_iam_role" "tts_management_fullAdmin_role" {
  name = "tts-${var.env}-management-fullAdmin"

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

#tts OPs admin role
resource "aws_iam_role" "tts_operations_iamAdmin_role" {
  name = "tts-${var.env}-operations-iamAdmin"

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

#IAM ROLE for AWS Config
resource "aws_iam_role" "config" {
  name = "tts-${var.env}-config-service"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

#Policy Section #

#policy for MFA
resource "aws_iam_policy" "tts_mfa" {
  name = "tts-${var.env}-mfa"
  path = "/"
  description = "Forces iam users to set MFA to access services"
  policy = "${file("${path.module}/files/tts_all_forceMfa_iam_policy.json")}"
}



#Policy for RemoteSourceIPRestriction
resource "aws_iam_policy" "tts_remoteAccess_policy" {
  name = "tts-${var.env}-remoteAccess-policy"
  description = "Restrict remote access to whitelisted source IPs"

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":{
      "Effect":"Deny",
      "Action":"*",
      "Resource":"*",
      "Condition":{  
         "NotIpAddress":{  
            "aws:SourceIp":[  
               "${var.ip_whitelist}"
            ]
         }
      }
   }
}
EOF
}

#Read Only Policy
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "tts_management_assumeBilling_policy" {
  name        = "tts-management-assumeBilling"
  description = "Allow access to assume role for view only access to billing and usage"

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {  
         "Sid":"Stmt1517950478000",
         "Effect":"Allow",
         "Action":[  
            "sts:AssumeRole"
         ],
         "Resource":[  
            "arn:aws:iam::*:role/tts-${var.env}-management-billing"
         ]
      }
   ]
}
EOF
}

# billing policy
resource "aws_iam_policy" "tts_management_billing_policy" {
  name = "tts-management-billing-policy"
  description = "Policy to allow access to view Billing and Usage data "

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {  
         "Sid":"VisualEditor0",
         "Effect":"Allow",
         "Action":[  
            "aws-portal:ViewPaymentMethods",
            "aws-portal:ViewAccount",
            "aws-portal:ViewBilling",
            "aws-portal:ViewUsage",
            "cur:DescribeReportDefinitions"
         ],
         "Resource":"*"
      },
      {  
         "Sid":"VisualEditor1",
         "Effect":"Allow",
         "Action":"budgets:ViewBudget",
         "Resource":"arn:aws:budgets::994389167892:budget/*"
      }
   ]
}

EOF
}

#assume admin policy
resource "aws_iam_policy" "tts_operations_assumeIamAdmin_policy" {
  name        = "tts-${var.env}-operations-assumeIamAdmin"
  description = "Switch role to manage IAM "

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {  
         "Effect":"Allow",
         "Action":[  
            "sts:AssumeRole"
         ],
         "Resource":[  
            "arn:aws:iam::*:role/tts-${var.env}-operations-iamAdmin"
         ]
      }
   ]
}
EOF
}

# assume fulladmin policy
resource "aws_iam_policy" "tts_management_assumeFullAdmin_policy" {
  name = "tts-${var.env}-management-assumeFullAdmin"
  description = "Break glass - switch role to gain full admin rights and Organizations access"

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {  
         "Effect":"Allow",
         "Action":[  
            "sts:AssumeRole"
         ],
         "Resource":[  
            "arn:aws:iam::*:role/tts-${var.env}-management-orgAdmin",
            "arn:aws:iam::${var.aws_account_id}:role/tts-${var.env}-management-fullAdmin"
         ]
      }
   ]
}
EOF
}

#TTS secops IR policy
resource "aws_iam_policy" "tts_secops_incidentResponse_policy" {
  name        = "tts-${var.env}-secops-incidentResponse"
  description = "SecOps incident response policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
		"acm:*",
                "apigateway:*",
                "artifact:*",
                "autoscaling:*",
                "batch:*",
                "cloudformation:*",
                "cloudfront:*",
                "cloudhsm:*",
                "cloudtrail:*",
                "cloudwatch:*",
                "config:*",
                "directconnect:*",
                "ds:*",
                "ec2:*",
                "ecr:*",
                "ecs:*",
                "elasticbeanstalk:*",
                "events:*",
                "guardduty:*",
                "iam:*",
                "inspector:*",
                "lightsail:*",
                "logs:*",
                "opsworks:*",
                "route53:*",
                "s3:*",
                "servicecatalog:*",
                "shield:*",
                "ssm:AddTagsToResource",
                "ssm:CancelCommand",
                "ssm:CreateActivation",
                "ssm:CreateAssociation",
                "ssm:CreateAssociationBatch",
                "ssm:CreateDocument",
                "ssm:CreateMaintenanceWindow",
                "ssm:CreatePatchBaseline",
                "ssm:CreateResourceDataSync",
                "ssm:DeleteActivation",
                "ssm:DeleteAssociation",
                "ssm:DeleteDocument",
                "ssm:DeleteMaintenanceWindow",
                "ssm:DeletePatchBaseline",
                "ssm:DeleteResourceDataSync",
                "ssm:DeregisterManagedInstance",
                "ssm:DeregisterPatchBaselineForPatchGroup",
                "ssm:DeregisterTargetFromMaintenanceWindow",
                "ssm:DeregisterTaskFromMaintenanceWindow",
                "ssm:DescribeActivations",
                "ssm:DescribeAssociation",
                "ssm:DescribeAutomationExecutions",
                "ssm:DescribeAutomationStepExecutions",
                "ssm:DescribeAvailablePatches",
                "ssm:DescribeDocument",
                "ssm:DescribeDocumentParameters",
                "ssm:DescribeDocumentPermission",
                "ssm:DescribeEffectiveInstanceAssociations",
                "ssm:DescribeEffectivePatchesForPatchBaseline",
                "ssm:DescribeInstanceAssociationsStatus",
                "ssm:DescribeInstanceInformation",
                "ssm:DescribeInstancePatches",
                "ssm:DescribeInstancePatchStates",
                "ssm:DescribeInstancePatchStatesForPatchGroup",
                "ssm:DescribeInstanceProperties",
                "ssm:DescribeMaintenanceWindowExecutions",
                "ssm:DescribeMaintenanceWindowExecutionTaskInvocations",
                "ssm:DescribeMaintenanceWindowExecutionTasks",
                "ssm:DescribeMaintenanceWindows",
                "ssm:DescribeMaintenanceWindowTargets",
                "ssm:DescribeMaintenanceWindowTasks",
                "ssm:DescribePatchBaselines",
                "ssm:DescribePatchGroups",
                "ssm:DescribePatchGroupState",
                "ssm:GetAutomationExecution",
                "ssm:GetCommandInvocation",
                "ssm:GetDefaultPatchBaseline",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:GetInventory",
                "ssm:GetInventorySchema",
                "ssm:GetMaintenanceWindow",
                "ssm:GetMaintenanceWindowExecution",
                "ssm:GetMaintenanceWindowExecutionTask",
                "ssm:GetMaintenanceWindowExecutionTaskInvocation",
                "ssm:GetMaintenanceWindowTask",
                "ssm:GetManifest",
                "ssm:GetPatchBaseline",
                "ssm:GetPatchBaselineForPatchGroup",
                "ssm:ListAssociations",
                "ssm:ListAssociationVersions",
                "ssm:ListCommandInvocations",
                "ssm:ListCommands",
                "ssm:ListDocuments",
                "ssm:ListDocumentVersions",
                "ssm:ListInstanceAssociations",
                "ssm:ListInventoryEntries",
                "ssm:ListResourceDataSync",
                "ssm:ListTagsForResource",
                "ssm:ModifyDocumentPermission",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:PutInventory",
                "ssm:RegisterDefaultPatchBaseline",
                "ssm:RegisterPatchBaselineForPatchGroup",
                "ssm:RegisterTargetWithMaintenanceWindow",
                "ssm:RegisterTaskWithMaintenanceWindow",
                "ssm:RemoveTagsFromResource",
                "ssm:SendAutomationSignal",
                "ssm:SendCommand",
                "ssm:StartAssociationsOnce",
                "ssm:StartAutomationExecution",
                "ssm:StopAutomationExecution",
                "ssm:UpdateAssociation",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateDocument",
                "ssm:UpdateDocumentDefaultVersion",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation",
                "ssm:UpdateMaintenanceWindow",
                "ssm:UpdateMaintenanceWindowTarget",
                "ssm:UpdateMaintenanceWindowTask",
                "ssm:UpdateManagedInstanceRole",
                "ssm:UpdatePatchBaseline",
                "sso:*",
                "trustedadvisor:*",
                "waf:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#tts ops admin policy
resource "aws_iam_policy" "tts_operations_iamAdmin_policy" {
  name = "tts-${var.env}-operations-iamAdmin-policy"
  description = "Policy to allow full access to manage IAM resources"

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {  
         "Effect":"Allow",
         "Action":"iam:*",
         "Resource":"*"
      }
   ]
}
EOF
}

#tts mgmt full admin policy
resource "aws_iam_policy" "tts_management_fullAdmin_policy" {
  name        = "tts-${var.env}-management-fullAdmin-policy"
  description = "Policy to allow full admin access"

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
      {  
         "Effect":"Allow",
         "Action":"*",
         "Resource":"*"
      }
   ]
}
EOF
}

##Policies Attachments Section##

#billing assume
resource "aws_iam_group_policy_attachment" "tts_management_assumeBilling_attach" {
  group = "${aws_iam_group.finance_group.name}"
  policy_arn = "${aws_iam_policy.tts_management_assumeBilling_policy.arn}"
}

#TTS assume IAM ADMIN
resource "aws_iam_group_policy_attachment" "tts_operations_assumeIamAdmin_attach" {
  group = "${aws_iam_group.userManagement_group.name}"
  policy_arn = "${aws_iam_policy.tts_operations_assumeIamAdmin_policy.arn}"
}

# Full admin
resource "aws_iam_group_policy_attachment" "tts_management_assumeFullAdmin_attach" {
  group = "${aws_iam_group.fullAdmin_group.name}"
  policy_arn = "${aws_iam_policy.tts_management_assumeFullAdmin_policy.arn}"
}

resource "aws_iam_group_policy_attachment" "tts_secops_incidentResponse_attach" {
  group = "${aws_iam_group.incidentResponse_group.name}"
  policy_arn = "${aws_iam_policy.tts_secops_incidentResponse_policy.arn}"
}

# billing policy attach

resource "aws_iam_role_policy_attachment" "tts_management_billing_attach" {
  role = "${aws_iam_role.tts_management_billing_role.name}"
  policy_arn = "${aws_iam_policy.tts_management_billing_policy.arn}"
}

# admin attach
resource "aws_iam_role_policy_attachment" "tts_operations_iamAdmin_attach" {
  role = "${aws_iam_role.tts_operations_iamAdmin_role.name}"
  policy_arn = "${aws_iam_policy.tts_operations_iamAdmin_policy.arn}"
}

#tts mgmt full admin attach
resource "aws_iam_role_policy_attachment" "tts_management_fullAdmin_attach" {
  role = "${aws_iam_role.tts_management_fullAdmin_role.name}"
  policy_arn = "${aws_iam_policy.tts_management_fullAdmin_policy.arn}"
}

#IAM Policy for AWS Config
resource "aws_iam_role_policy_attachment" "config" {
  role = "${aws_iam_role.config.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy_attachment" "organization" {
  role = "${aws_iam_role.config.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

#circle CI policy
resource "aws_iam_user_policy_attachment" "deployer_attach" {
  user = "${aws_iam_user.deployer.name}"
  policy_arn = "${aws_iam_policy.tts_Region_Restricted_PowerUserAccess_Deployer.arn}"
}

