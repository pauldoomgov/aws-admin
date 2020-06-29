---
name: New account
about: Checklist for creating new AWS account
title: ""
labels: ""
assignees: ""
---

## Who/what the account is for?

<!-- response here -->

## Do you need an associated GovCloud account?

<!-- response here -->

## Checklist for admins

1. [ ] [Confirm they are paying into the existing contract](https://docs.google.com/spreadsheets/d/1DedSCiU9AsCAAVvAFZT0_Ii7AFIKlI-JNifzlpHNbDg/edit#gid=1269506691)
1. [ ] [Create an account](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html#orgs_manage_accounts_create-new) using email `devops+aws-<program>-<env>@gsa.gov`
1. [ ] Set up root user
   1. [ ] [Sign in as the root user](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html#orgs_manage_accounts_access-as-root)
   1. [ ] [Change account email](https://console.aws.amazon.com/billing/home#/account) to `devops+aws-<account number>@gsa.gov`
   1. [ ] [Set up MFA](https://console.aws.amazon.com/iam/home?#/security_credentials)
   1. [ ] [Add to KeePass](https://drive.google.com/drive/folders/1iQnvC8o_MU_DR5u7TYtC9pEKZXtBq03f?usp=sharing) and re-upload database
1. [ ] Set the [program team mailing list](https://docs.google.com/spreadsheets/d/12pfcEIEXaJTjIKex-3wnI89erIvgKf9B_XpGkDl6qsM/edit#gid=1235102795) as the [Operations Contact](https://console.aws.amazon.com/billing/home?#/account)
1. [ ] Add to [account spreadsheet](https://docs.google.com/spreadsheets/d/1DedSCiU9AsCAAVvAFZT0_Ii7AFIKlI-JNifzlpHNbDg/edit#gid=0)
1. [ ] If GovCloud is needed, send a request with the account number to govcloud-onboarding@amazon.com and CC cloudteam@4points.com, devops@gsa.gov, and brian.burns@gsa.gov
1. [ ] Set up cross-account access
   1. [ ] [Create a role for "another AWS account"](https://console.aws.amazon.com/iam/home#/roles$new?step=type&roleType=crossAccount). For the `Account ID`, enter `133032889584`.
   1. [ ] Select the [`AdministratorAccess`](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_administrator) policy.
   1. [ ] Add a tag of `Project`: `https://github.com/18F/aws-admin`.
   1. [ ] Set a `Role name` of `CrossAccountAdmin`.
   1. [ ] Create it.
   1. [ ] Mark a `Y` in the `Role switching enabled?` column of [the AWS accounts list](https://docs.google.com/spreadsheets/d/1DedSCiU9AsCAAVvAFZT0_Ii7AFIKlI-JNifzlpHNbDg/edit#gid=0)
1. [ ] Set up IAM
   1. [ ] [Create a group](https://console.aws.amazon.com/iam/home#/groups) called `Administrators`
   1. [ ] Attach the `AdministratorAccess` policy to that group
   1. [ ] Create an IAM user in the `Administrators` group for the requester
   1. [ ] Send them the temporary password via Google Hangouts
