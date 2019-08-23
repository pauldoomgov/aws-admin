# TTS CORE - IAM

## Overview
Creates the foundation for many of the Identity and Access Management (IAM) resources required for TTS. The repository contains IAM resource settings specifically designed for deployment into either development or production environments.
This includes:

* Deployer user and policy for CI/CD
* IAM Groups and associated Policies
* IAM Roles
* IAM Password Policy
* IAM Policy to enforce MFA
* IAM Policy for secops

## Variables

Some variables are required and do not have default values. Those variables must be filled in by you. Otherwise, you can accept the default values if they meet your needs.

| Variable                       | Description               | Required   | Initial value  |
|--------------------------------|---------------------------|------------|----------------|
| env                            | App Environment           | Yes        | sandbox        |
| aws_account_id                  | AWS Account ID           | Yes         |      |

