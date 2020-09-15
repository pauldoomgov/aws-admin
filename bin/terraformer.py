#!/usr/bin/env python

# Runs an AWS CLI subcommand across all profiles in your AWS configuration file by replacing `aws` with `./all_profiles.py`.
#
#   ./all_profiles.py [subcommand] [args]
#
# Useful in conjunction with the config file created by Terraform.
#
# https://github.com/18F/aws-admin#locally
#
# Example use:
#
#   AWS_DEFAULT_REGION=us-gov-west-1 ./all_profiles.py ec2 describe-instances

import boto3
import sys
import subprocess

session = boto3.Session()

for profile in session.available_profiles:
    print("+ PROFILE:", profile)
    
    cmd = ["terraformer", "import", "aws", "--profile=",profile, "--regions=","us-east-1,us-east-2,us-west-1,us-west-2,us-central-1,us-central-2", "--path-output=./aws/",profile] + sys.argv[1:]
    subprocess.run(cmd)
