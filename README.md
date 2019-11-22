# TTS-wide AWS Account Adminstration

This repository contains AWS cross-account management for the [Technology Transform Service (TTS)](http://www.gsa.gov/portal/category/25729) and is managed by the [TTS Technology Portfolio](https://handbook.18f.gov/tech-portfolio/) within the [General Services Administration](http://gsa.gov).

## Setup

1. [Set up AWS credentials](https://blog.gruntwork.io/authenticating-to-aws-with-the-credentials-file-d16c0fbcbf9e) for the AWS account `133032889584`
1. [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
1. Clone this repository
1. Set up Terraform

   ```sh
   cd aws-admin/terraform
   terraform init
   ```

1. Confirm the AWS connection works

   ```sh
   terraform plan
   ```

## Cross-account access

_Based on [these steps](https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html)._

**Source account: `133032889584`**

### Adding a new destination account

1. [Log in](https://console.aws.amazon.com/console/home) to the destination account.
1. [Create a role for "another AWS account"](https://console.aws.amazon.com/iam/home#/roles$new?step=type&roleType=crossAccount). For the `Account ID`, enter `133032889584`.
1. Select the [`AdministratorAccess`](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_administrator) policy.
1. Add a tag of `Project`: `https://github.com/18F/aws-admin`.
1. Set a `Role name` of `CrossAccountAdmin`.
1. Create it.
1. Using credentials for the source account, run a `terraform apply` from this directory.

### Signing in to destination accounts

1. [Log in to the source account using IAM](https://133032889584.signin.aws.amazon.com/console)
1. Use the `Switch role URL` from the [AWS accounts list](https://docs.google.com/spreadsheets/d/1DedSCiU9AsCAAVvAFZT0_Ii7AFIKlI-JNifzlpHNbDg/edit#gid=0)

[More info.](https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/id_roles_use_switch-role-console.html)
