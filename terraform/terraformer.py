#!/usr/bin/env python

# Runs terraformer https://github.com/GoogleCloudPlatform/terraformer#capabilities to export existing AWS resources into terraform
# 
# Setup
# $ brew install terraformer
# $ cd terraform
# $ ./terraformer.py [subcommand] [args] --resources=iam
# $ ./terraformer.py [subcommand] [args]
#
# Useful in conjunction with the config file created by Terraform.
#
# https://github.com/18F/aws-admin#locally
#
# Example use:
#
#   export AWS_DEFAULT_REGION=us-east-1 && ./terraformer.py --resources=iam

import boto3
import sys
import subprocess

session = boto3.Session()

for profile in session.available_profiles:
    print("+ PROFILE:", profile)
    
    cmd = ["terraformer", "import", "aws", "--profile=" + profile, "--path-output=./aws/" + profile] + sys.argv[1:]
    subprocess.run(cmd)
