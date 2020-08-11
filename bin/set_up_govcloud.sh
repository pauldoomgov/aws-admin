#!/bin/bash

set -e
set -x

# required environment variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# USERNAME (optional - set on system by default)

# based on
# https://govcloudconsolesetup.s3-us-gov-west-1.amazonaws.com/setup.html

export AWS_DEFAULT_REGION=us-gov-west-1
GROUP_NAME=Administrators

aws iam create-group --group-name "$GROUP_NAME"

# Command to Add a Policy to the group:
aws iam attach-group-policy --group-name "$GROUP_NAME" --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Command to create a new user and add them to the group:
aws iam create-user --user-name "$USERNAME"
aws iam add-user-to-group --group-name "$GROUP_NAME" --user-name "$USERNAME"

# turn off echoing
set +x

# Read Password
echo -n "Password for new IAM user ($USERNAME): "
read -s PASSWORD
echo

# Command to add a password to the user:
aws iam create-login-profile --user-name "$USERNAME" --password "$PASSWORD"
unset $PASSWORD

# re-enable echoing
set -x

# Command to Verify that your user was created:
aws iam list-users

GOVCLOUD_ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)
echo "Sign in as $USERNAME at https://$GOVCLOUD_ACCOUNT_NUMBER.signin.amazonaws-us-gov.com/console"
