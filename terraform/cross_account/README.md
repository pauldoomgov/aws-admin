# AWS cross-account access

_Based on [these steps](https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html)._

To add a new destination account:

1. [Log in](https://console.aws.amazon.com/console/home) to the destination account.
1. [Create a role for "another AWS account"](https://console.aws.amazon.com/iam/home#/roles$new?step=type&roleType=crossAccount). For the `Account ID`, enter `133032889584`.
1. Select the [`AdministratorAccess`](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_administrator) policy.
1. Add a tag of `Project`: `https://github.com/18F/aws-admin`.
1. Set a `Role name` of `CrossAccountAdmin`.
1. Create it.
1. Add to the [`dest_account_numbers`](vars.tf).
1. Using credentials for the AWS account `133032889584`, run a `terraform apply` from this directory.

[More about switching roles.](https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/id_roles_use_switch-role-console.html)
