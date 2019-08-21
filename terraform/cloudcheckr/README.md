# TTS CORE - CloudCheckr

## Overview
Creates the necessary IAM role, and policies to integrate with CloudCheckr SaaS

This includes:

* Enable Security Access
* Enable Inventory Access
* Enable CloudWatch Flow Logs Access

## Variables

Some variables are required and do not have default values. Those variables must be filled in by you. Otherwise, you can accept the default values if they meet your needs.

| Variable  | Description | Required | Initial value |
|---|---|---|---|
| account_id | CloudCheckr Account ID | Yes |  |
| external_id | CloudCheckr External ID | Yes | |
| cloudtrail_bucket | CloudTrail Bucket Name | No | |
| enable | Enables CloudCheckr module | Yes | true |
| enable_security | Enable CloudCheckr security access | Yes | true |
| enable_inventory | Enable CloudCheckr inventory access | Yes | true |
| enable_cloudwatch | Enable CloudCheckr CloudWatch flog log access | Yes | true |
