# TTS-wide AWS Account Adminstration

This repository contains AWS Cross Account user management for the [Technology Transform Service (TTS)](http://www.gsa.gov/portal/category/25729) and is management by the [TTS Technology Portfolio](https://handbook.18f.gov/tech-portfolio/) within the [General Services Administration](http://gsa.gov)).

## Overview
Creates the standardized IAM roles and policies for TTS AWS Accounts. This includes:

#### [iam](/terraform/iam)
* Technology Portfolio Cross Account "break glass" admin access.
* CloudWatch Flow Logs Access to Payer Account *Optionally: GSA SecOps Enterprise Logging*.
* Enforces GSA's MFA and Password polices.
* Continous Integration read-only role for future configuration and compliance auditing.

#### [cloudcheckr](/terraform/cloudcheckr)
* CloudCheckr Inventory access *w/ optional Security/Cleanup/Cost/Usage extended policies*.

#### [guardduty](/terraform/guardduty)
* Guardduty security alerting

#### [app](/terraform/app)
* Allow account owners to customize their policies by the type of workload the account handles:
    * sandbox *default*
    * test
    * development
    * staging
    * production

## Variables

Some variables are required and do not have default values. Those variables must be filled in by you. Otherwise, you can accept the default values if they meet your needs.

| Variable  | Description | Required | Initial value |
|---|---|---|---|
| backend_bucket | s3 bucket for Terraform .tfstate  | Yes |  |
| appenv | customize policies per AWS account environment/type `test | development | staging | production` | Yes | `sandbox` |
| cc_account_id | TTS CloudCheckr account id | Yes | |
| cc_external_id | Cloudcheckqr AWS Account| Yes | |
| ip_whitelist | optionally restrict AWS account to IP address | No | |

### Credits

This repository is based on [GSA's GRACE Platform](https://github.com/gsa?utf8=✓&q=grace&type=&language=)

### Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
