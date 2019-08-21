# TTS CORE AWS Cross Account IAM 

## Overview
Creates the standardized IAM roles and policies for TTS AWS Accounts. This includes:

#### [iam](/iam)
* Technology Portfolio Cross Account "break glass" admin access.
* CloudWatch Flow Logs Access to Payer Account *Optionally: GSA SecOps Enterprise Logging*.
* Enforces GSA's MFA and Password polices.
* Continous Integration read-only role for future configuration and compliance auditing.

#### [cloudcheckr](/cloudcheckr)
* CloudCheckr Inventory access *w/ optional Security/Cleanup/Cost/Usage extended policies*.

#### [guardduty](/guardduty)
* Guardduty security alerting

#### [app](/app)
* Allow account owners to customize their policies by the type of workload the account handles:
    * development
    * test
    * staging
    * production

## Variables

Some variables are required and do not have default values. Those variables must be filled in by you. Otherwise, you can accept the default values if they meet your needs.

| Variable  | Description | Required | Initial value |
|---|---|---|---|
| backend_bucket | s3 bucket for Terraform .tfstate  | Yes |  |
| appenv | customize variables/policies per AWS account environment/type | Yes | `test | development | staging | production` |
| cc_account_id | TTS CloudCheckr account id | Yes | |
| cc_external_id | Cloudcheckqr AWS Account| Yes | |
| ip_whitelist | optionally restrict AWS account to IP address | No | |

