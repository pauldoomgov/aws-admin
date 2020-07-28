---
name: New sandbox user
about: Checklist for creating new sandbox users
title: "sandbox account for [your email]"
labels: ""
assignees: ""
---

_By making this request, you are agreeing to [the rules](https://before-you-ship.18f.gov/infrastructure/sandbox/#rules)._

## For admins

1. [ ] Sign into the sandbox account, either directly or through [cross-account access](https://github.com/18F/aws-admin#signing-in-to-destination-accounts)
1. [ ] [Add a new user](https://console.aws.amazon.com/iam/home#/users$new?step=details)
   - Use their GSA email as their username
   - Enable `AWS Management Console access`
   - Add to group `sandbox-power-user`
1. [ ] Send them the temporary password via Google Hangouts
1. [ ] Have them confirm they set up MFA
