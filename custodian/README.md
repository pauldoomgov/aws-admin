# Cloud Custodian
A repo containing rule sets for cloud-custodian inside GSA TTS AWS accounts. This repo does not contain cloud-custodian itself.

## What is this
Cloud Custodian is a tool that unifies the dozens of tools and scripts most organizations use for managing their AWS accounts into one open source tool. It’s a stateless rules engine for policy definition and enforcement, with metrics and reporting for AWS.

http://www.capitalone.io/cloud-custodian/docs/
https://github.com/capitalone/cloud-custodian

## Use Cases
<details>
<summary>Examples</summary>

#### Cost Savings:
* Resource Off Hours: Easy way to cut expenses by t urning on/off resources on a automated schedule.
* Resource Resizing: Ability to automatically resize resources based on metrics over time.
* Garbage Collection: Automatic notifications and removal of stale and unused resources.

#### Compliance:
* Encryption: Verify and enforce encryption across numerous resources.
* Backups: Performs automated snapshots of servers and databases.
* Tag Enforcement: Proper tags are necessary for resource support and tracking.
* Security: Puts up automated safeguards to detect, remediate, and notify customers of non-compliant actions
* Standards: Ensure certain standards are used with consistency across all managed AWS accounts.

#### Examples:
* Verifies CloudTrail Logging is enabled and configured properly
* Verifies Network Logging is enabled and configured properly
* Verifies Root user’s access keys have been deleted
* Verifies MFA Token has been applied to Root user
* Verifies proper IAM password policy is enforced for users

### Variables
There are several variables that are capitalized throughout, some include `MESSAGEQUEUENAME, BUCKETNAME, and REQUIREDTAGS` These should be substituted and variablized to your environment needs.

### Custodian Logging/Metrics
`execution-options:output_dir: s3://BUCKETNAME/CustodianLogs/{account_id}/`
This specific option is used to send the cusotdian run log and resources log to an s3 bucket. The data in the s3 bucket may be ingested by SIEM or other tools for customized metrics and data visualization.

Note, there are other ways to ingest these files that can be found in the `custodian reporting features` link below

### Slack integration
`to: ["slack"]`
Here you can see the configuration in how we use SQS to send to directly to SLACK. This actually sends the content of the "resources.json.gz" file directly into a slack channel. This option requires you to create a message queue that is used by the Custodian to send to slack. We speak more about the logs/metrics file contents in our blog post below.

</details>
## Getting Started
<details>
<summary>Quick Install</summary>

Cloud custodian requires [python3, pipenv](https://github.com/pypa/pipenv) be installed on your client machine or [with docker using `docker exec` or `docker run`](https://github.com/capitalone/cloud-custodian/blob/master/Dockerfile) 

From root directory `$ cd custodian`

```bash
$ brew install pipenv
$ pipenv install
$ pipenv shell
(custodian) $ c7n-org run -c accounts.yml -s output -u inventory/test.yml
```

[Add schema support to vscode](https://cloudcustodian.io/docs/quickstart/index.html#editor-integration)
```
$ cd custodian
$ pipenv shell
$ custodian schema --json > schema.json
Go to vscode settings.json (Preferences -> Settings -> Extensions -> YAML)
Copy path to schema.json to path as a new entry under `yaml.schema`
```

Use c7n-org report to generate csv results
```
$ cd custodian
$ pipenv shell
$ c7n-org report -c accounts.yml -s output -u inventory/test.yml > output/test-report.csv
```

>If you plan to use Cloud Custodian to enforce rules as lambda functions from Cloudtrial or perform actions on resources (e.g. turn on encyrption/backups, resize/start/stop resources that IAM will need more than `ReadOnlyAccess` to those resources (use common sense least-priviledge principles to restrict to only those set of permissions per resources to be managed by Cloud Custodian)
</details>

## Concepts
<details>
<summary>Basics</summary>

Cloud Custodian uses a YAML structure for rules. Rules are used to check state, filters and actions are used to query that state (filters) to trigger emails/alerts/remediation (actions) based on the filter's result.


#### Basic Layout
```yaml
name: Name for the policy
resource: Which resource type to check (ec2, rds, ebs, etc 100+)
description: |
    Brief statement of what the policy does
mode: How/when the policy will be executed (e.g. event(API Triggered), periodic(Cron Scheduled), config(Config Change Triggered), no mode is needed for manual runs)
- filters: Narrow down resource matches with 1 or more of these (See filters below)
- actions: What to do with the resulting resource set found. (notify by email/sns/webhook or perform an operation `mark-for-op` stop, start, terminate, tag, resize, etc)
```

#### Filters
* Operator matching (in, not-in, absent, not-null, gte, regex, etc)
* Arbitrary nesting of filters with ‘or’ and ‘and’ blocks.
* Simple key/value are equality matches with value expressions

`regex` fliters use Jmespath expressions: http://jmespath.org/

#### Actions
</details>

#### Complete Schema
<details>
<summary>Resources, Actions, and Filters</summary>

credits: https://github.com/jtroberts83/Cloud-Custodian/blob/master/schema_expander/schema_quick_ref.txt

```yaml

---
# Cloud Custodian Quick Reference
aws.account:
  actions:
  - enable-cloudtrail
  - enable-data-events
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - request-limit-increase
  - set-ebs-encryption
  - set-s3-public-block
  - set-shield-advanced
  - set-xray-encrypt
  - webhook
  filters:
  - check-cloudtrail
  - check-config
  - credential
  - default-ebs-encryption
  - event
  - finding
  - glue-security-config
  - guard-duty
  - has-virtual-mfa
  - iam-summary
  - missing
  - ops-item
  - password-policy
  - s3-public-block
  - service-limit
  - shield-enabled
  - value
  - xray-encrypt-key

aws.acm-certificate:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - health-event
  - marked-for-op
  - ops-item
  - value

aws.alarm:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - ops-item
  - value

aws.ami:
  actions:
  - auto-tag-user
  - copy
  - copy-related-tag
  - deregister
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-launch-permissions
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - image-age
  - marked-for-op
  - ops-item
  - tag-count
  - unused
  - value

# Resource manager for v2 ELBs (AKA ALBs and NLBs).
aws.app-elb:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-listener
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-s3-logging
  - set-shield
  - set-waf
  - tag
  - webhook
  filters:
  - config-compliance
  - default-vpc
  - event
  - finding
  - health-event
  - healthcheck-protocol-mismatch
  - is-logging
  - is-not-logging
  - listener
  - marked-for-op
  - metrics
  - network-location
  - ops-item
  - security-group
  - shield-enabled
  - subnet
  - tag-count
  - target-group
  - value
  - vpc
  - waf-enabled


# Resource manager for v2 ELB target groups.
aws.app-elb-target-group:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - default-vpc
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.asg:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - propagate-tags
  - put-metric
  - remove-tag
  - rename-tag
  - resize
  - resume
  - suspend
  - tag
  - tag-trim
  - webhook
  filters:
  - capacity-delta
  - config-compliance
  - event
  - finding
  - image
  - image-age
  - invalid
  - launch-config
  - marked-for-op
  - metrics
  - network-location
  - not-encrypted
  - offhour
  - onhour
  - ops-item
  - progagated-tags
  - security-group
  - subnet
  - tag-count
  - user-data
  - valid
  - value
  - vpc-id



aws.backup-plan:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.batch-compute:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - update-environment
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - security-group
  - subnet
  - value



aws.batch-definition:
  actions:
  - deregister
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.cache-cluster:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - snapshot
  - tag
  - webhook
  filters:
  - event
  - finding
  - health-event
  - marked-for-op
  - metrics
  - network-location
  - ops-item
  - security-group
  - subnet
  - tag-count
  - value



aws.cache-snapshot:
  actions:
  - auto-tag-user
  - copy-cluster-tags
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - age
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.cache-subnet-group:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.cfn:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-protection
  - tag
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - ops-item
  - value



aws.cloud-directory:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - value



aws.cloudhsm-cluster:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.cloudsearch:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - metrics
  - ops-item
  - value



aws.cloudtrail:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-logging
  - tag
  - update-trail
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - is-shadow
  - marked-for-op
  - ops-item
  - status
  - value



aws.codebuild:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - security-group
  - subnet
  - value
  - vpc



aws.codecommit:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.codepipeline:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.config-recorder:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.config-rule:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - status
  - value



aws.customer-gateway:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.datapipeline:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.dax:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - update-cluster
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - marked-for-op
  - ops-item
  - security-group
  - subnet
  - value



aws.directconnect:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - health-event
  - ops-item
  - value



aws.directory:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - health-event
  - ops-item
  - security-group
  - subnet
  - value
  - vpc



aws.distribution:
  actions:
  - auto-tag-user
  - copy-related-tag
  - disable
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-protocols
  - set-shield
  - set-waf
  - tag
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - marked-for-op
  - metrics
  - mismatch-s3-origin
  - ops-item
  - shield-enabled
  - shield-metrics
  - tag-count
  - value
  - waf-enabled



aws.dlm-policy:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.dms-endpoint:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - modify-endpoint
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.dms-instance:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-instance
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - health-event
  - kms-key
  - marked-for-op
  - ops-item
  - security-group
  - subnet
  - value
  - vpc



aws.dynamodb-backup:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.dynamodb-stream:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - metrics
  - ops-item
  - value



aws.dynamodb-table:
  actions:
  - auto-tag-user
  - backup
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-stream
  - tag
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - health-event
  - kms-key
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.ebs:
  actions:
  - auto-tag-user
  - copy-instance-tags
  - copy-related-tag
  - delete
  - detach
  - encrypt-instance-volumes
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - snapshot
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - fault-tolerant
  - finding
  - health-event
  - instance
  - kms-alias
  - marked-for-op
  - metrics
  - modifyable
  - ops-item
  - tag-count
  - value



aws.ebs-snapshot:
  actions:
  - auto-tag-user
  - copy
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - age
  - cross-account
  - event
  - finding
  - marked-for-op
  - ops-item
  - skip-ami-snapshots
  - tag-count
  - unused
  - value



aws.ec2:
  actions:
  - auto-tag-user
  - autorecover-alarm
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - propagate-spot-tags
  - put-metric
  - reboot
  - remove-tag
  - rename-tag
  - resize
  - send-command
  - set-instance-profile
  - snapshot
  - start
  - stop
  - tag
  - tag-trim
  - terminate
  - webhook
  filters:
  - check-permissions
  - config-compliance
  - default-vpc
  - ebs
  - ephemeral
  - event
  - finding
  - health-event
  - image
  - image-age
  - instance-age
  - instance-attribute
  - instance-uptime
  - marked-for-op
  - metrics
  - network-location
  - offhour
  - onhour
  - ops-item
  - security-group
  - singleton
  - ssm
  - state-age
  - subnet
  - tag-count
  - termination-protected
  - user-data
  - value
  - vpc



aws.ec2-reserved:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.ecr:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - remove-tag
  - set-immutability
  - set-lifecycle
  - set-scanning
  - tag
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - lifecycle-rule
  - marked-for-op
  - ops-item
  - value



aws.ecs:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.ecs-container-instance:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-state
  - tag
  - update-agent
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - taggable
  - value



aws.ecs-service:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - taggable
  - task-definition
  - value



aws.ecs-task:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - stop
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - taggable
  - task-definition
  - value



aws.ecs-task-definition:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - value



aws.efs:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - health-event
  - kms-key
  - marked-for-op
  - metrics
  - ops-item
  - tag-count
  - value



aws.efs-mount-target:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - security-group
  - subnet
  - value



aws.eks:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - update-config
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - security-group
  - subnet
  - value
  - vpc



aws.elasticbeanstalk:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value


aws.elasticbeanstalk-environment:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - terminate
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.elasticsearch:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - security-group
  - subnet
  - value
  - vpc



aws.elb:
  actions:
  - auto-tag-user
  - delete
  - disable-s3-logging
  - enable-s3-logging
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-shield
  - set-ssl-listener-policy
  - tag
  - webhook
  filters:
  - config-compliance
  - default-vpc
  - event
  - finding
  - health-event
  - healthcheck-protocol-mismatch
  - instance
  - is-logging
  - is-not-logging
  - is-ssl
  - marked-for-op
  - metrics
  - network-location
  - ops-item
  - security-group
  - shield-enabled
  - shield-metrics
  - ssl-policy
  - subnet
  - tag-count
  - value
  - vpc


aws.emr:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - terminate
  - webhook
  filters:
  - event
  - finding
  - health-event
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.eni:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - set-flow-log
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - flow-logs
  - json-diff
  - marked-for-op
  - network-location
  - ops-item
  - security-group
  - subnet
  - tag-count
  - value
  - vpc



aws.event-rule:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - metrics
  - ops-item
  - value



aws.event-rule-target:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - ops-item
  - value



aws.firehose:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - encrypt-s3-destination
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.fsx:
  actions:
  - auto-tag-user
  - backup
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - update
  - webhook
  filters:
  - event
  - finding
  - kms-key
  - marked-for-op
  - ops-item
  - value



aws.fsx-backup:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - kms-key
  - marked-for-op
  - ops-item
  - value



aws.gamelift-build:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.gamelift-fleet:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.glacier:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - remove-tag
  - tag
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.glue-connection:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - security-group
  - subnet
  - value



aws.glue-crawler:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.glue-database:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.glue-dev-endpoint:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.glue-job:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.glue-table:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.health-event:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.healthcheck:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.hostedzone:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-query-logging
  - set-shield
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - query-logging-enabled
  - shield-enabled
  - tag-count
  - value



aws.hsm:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.hsm-client:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.hsm-hapg:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.iam-certificate:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.iam-group:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - check-permissions
  - config-compliance
  - event
  - finding
  - has-inline-policy
  - has-users
  - ops-item
  - usage
  - value



aws.iam-policy:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - check-permissions
  - config-compliance
  - event
  - finding
  - has-allow-all
  - ops-item
  - unused
  - usage
  - used
  - value



aws.iam-profile:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - unused
  - used
  - value



aws.iam-role:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - set-policy
  - tag
  - webhook
  filters:
  - check-permissions
  - config-compliance
  - cross-account
  - event
  - finding
  - has-inline-policy
  - has-specific-managed-policy
  - no-specific-managed-policy
  - ops-item
  - unused
  - usage
  - used
  - value



aws.iam-user:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-keys
  - remove-tag
  - set-groups
  - tag
  - webhook
  filters:
  - access-key
  - check-permissions
  - config-compliance
  - credential
  - event
  - finding
  - group
  - has-inline-policy
  - marked-for-op
  - mfa-device
  - ops-item
  - policy
  - usage
  - value



aws.identity-pool:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.internet-gateway:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - json-diff
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.iot:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.kafka:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - security-group
  - subnet
  - value



aws.key-pair:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.kinesis:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - encrypt
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - tag-count
  - value



aws.kinesis-analytics:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - value



aws.kms:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - grant-count
  - ops-item
  - value



aws.kms-key:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - remove-tag
  - set-rotation
  - tag
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - key-rotation-status
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.lambda:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - remove-tag
  - set-concurrency
  - tag
  - webhook
  filters:
  - check-permissions
  - config-compliance
  - cross-account
  - event
  - event-source
  - finding
  - marked-for-op
  - metrics
  - network-location
  - ops-item
  - reserved-concurrency
  - security-group
  - subnet
  - value
  - vpc


aws.lambda-layer:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - ops-item
  - value



aws.launch-config:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - age
  - config-compliance
  - event
  - finding
  - ops-item
  - unused
  - value



aws.launch-template-version:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.lightsail-db:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.lightsail-elb:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.lightsail-instance:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.log-group:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - retention
  - set-encryption
  - tag
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - last-write
  - marked-for-op
  - metrics
  - ops-item
  - tag-count
  - value



aws.message-broker:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - security-group
  - subnet
  - value



aws.ml-model:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.nat-gateway:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.network-acl:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - json-diff
  - marked-for-op
  - ops-item
  - s3-cidr
  - subnet
  - tag-count
  - value



aws.network-addr:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - release
  - remove-tag
  - rename-tag
  - set-shield
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - json-diff
  - marked-for-op
  - ops-item
  - shield-enabled
  - tag-count
  - value


aws.ops-item:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - update
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.opswork-cm:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.opswork-stack:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - stop
  - webhook
  filters:
  - event
  - finding
  - metrics
  - ops-item
  - value



aws.peering-connection:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - marked-for-op
  - missing-route
  - ops-item
  - tag-count
  - value



aws.r53domain:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.rds:
  actions:
  - auto-patch
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-db
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - resize
  - retention
  - set-public-access
  - set-snapshot-copy-tags
  - snapshot
  - start
  - stop
  - tag
  - tag-trim
  - upgrade
  - webhook
  filters:
  - config-compliance
  - db-parameter
  - default-vpc
  - event
  - finding
  - health-event
  - kms-alias
  - marked-for-op
  - metrics
  - network-location
  - offhour
  - onhour
  - ops-item
  - security-group
  - subnet
  - tag-count
  - upgrade-available
  - value
  - vpc



aws.rds-cluster:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-db-cluster
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - retention
  - snapshot
  - start
  - stop
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - metrics
  - network-location
  - offhour
  - onhour
  - ops-item
  - security-group
  - subnet
  - tag-count
  - value

  

aws.rds-cluster-param-group:
  actions:
  - copy
  - delete
  - invoke-lambda
  - invoke-sfn
  - modify
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - metrics
  - ops-item
  - value

  

aws.rds-cluster-snapshot:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - age
  - event
  - finding
  - ops-item
  - value


aws.rds-param-group:
  actions:
  - copy
  - delete
  - invoke-lambda
  - invoke-sfn
  - modify
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - metrics
  - ops-item
  - value



aws.rds-reserved:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value


aws.rds-snapshot:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - region-copy
  - remove-tag
  - restore
  - tag
  - webhook
  filters:
  - age
  - config-compliance
  - cross-account
  - event
  - finding
  - latest
  - marked-for-op
  - onhour
  - ops-item
  - tag-count
  - value



aws.rds-subnet-group:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - unused
  - value



aws.rds-subscription:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - ops-item
  - value



aws.redshift:
  actions:
  - auto-tag-user
  - delete
  - enable-vpc-routing
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-security-groups
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - retention
  - set-logging
  - set-public-access
  - snapshot
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - default-vpc
  - event
  - finding
  - kms-key
  - logging
  - marked-for-op
  - metrics
  - network-location
  - ops-item
  - param
  - security-group
  - subnet
  - value



aws.redshift-snapshot:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - revoke-access
  - tag
  - webhook
  filters:
  - age
  - config-compliance
  - cross-account
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.redshift-subnet-group:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - ops-item
  - value



aws.rest-account:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - update
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.rest-api:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - update
  - webhook
  filters:
  - config-compliance
  - cross-account
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.rest-resource:
  actions:
  - delete-integration
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - update-integration
  - update-method
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - rest-integration
  - rest-method
  - value



aws.rest-stage:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - update
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.rest-vpclink:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.route-table:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - route
  - subnet
  - tag-count
  - value



aws.rrset:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.s3:
  actions:
  - attach-encrypt
  - auto-tag-user
  - configure-lifecycle
  - delete
  - delete-bucket-notification
  - delete-global-grants
  - encrypt-keys
  - encryption-policy
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - no-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - remove-tag
  - remove-website-hosting
  - set-bucket-encryption
  - set-inventory
  - set-statements
  - tag
  - toggle-logging
  - toggle-versioning
  - webhook
  filters:
  - bucket-encryption
  - bucket-notification
  - config-compliance
  - cross-account
  - data-events
  - event
  - finding
  - global-grants
  - has-statement
  - inventory
  - is-log-target
  - marked-for-op
  - metrics
  - missing-policy-statement
  - no-encryption-statement
  - ops-item
  - value



aws.sagemaker-endpoint:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - value



aws.sagemaker-endpoint-config:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - value



aws.sagemaker-job:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - stop
  - tag
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.sagemaker-model:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - value



aws.sagemaker-notebook:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - start
  - stop
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - security-group
  - subnet
  - value



aws.sagemaker-transform-job:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - stop
  - tag
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.secrets-manager:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - marked-for-op
  - ops-item
  - value



aws.security-group:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - patch
  - post-finding
  - post-item
  - put-metric
  - remove-permissions
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - default-vpc
  - diff
  - egress
  - event
  - finding
  - ingress
  - json-diff
  - marked-for-op
  - ops-item
  - stale
  - tag-count
  - unused
  - used
  - value



aws.shield-attack:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.shield-protection:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.simpledb:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.snowball:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.snowball-cluster:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.sns:
  actions:
  - auto-tag-user
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - modify-policy
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - remove-tag
  - set-encryption
  - tag
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - kms-key
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.sqs:
  actions:
  - auto-tag-user
  - copy-related-tag
  - delete
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-statements
  - remove-tag
  - set-encryption
  - set-retention-period
  - tag
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - kms-key
  - marked-for-op
  - metrics
  - ops-item
  - value



aws.ssm-activation:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.ssm-managed-instance:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - send-command
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.ssm-parameter:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value


aws.step-machine:
  actions:
  - auto-tag-user
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.storage-gateway:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - health-event
  - ops-item
  - value



aws.streaming-distribution:
  actions:
  - auto-tag-user
  - copy-related-tag
  - disable
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - tag-count
  - value



aws.subnet:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - set-flow-log
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - flow-logs
  - json-diff
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.support-case:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.transit-attachment:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.transit-gateway:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - event
  - finding
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.user-pool:
  actions:
  - delete
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - event
  - finding
  - ops-item
  - value



aws.vpc:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - set-flow-log
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - dhcp-options
  - event
  - finding
  - flow-logs
  - internet-gateway
  - json-diff
  - marked-for-op
  - nat-gateway
  - ops-item
  - security-group
  - subnet
  - tag-count
  - value
  - vpc-attributes



aws.vpc-endpoint:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - cross-account
  - event
  - finding
  - ops-item
  - security-group
  - subnet
  - value
  - vpc



aws.vpn-connection:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - json-diff
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.vpn-gateway:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - normalize-tag
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - rename-tag
  - tag
  - tag-trim
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - json-diff
  - marked-for-op
  - ops-item
  - tag-count
  - value



aws.waf:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - json-diff
  - metrics
  - ops-item
  - value



aws.waf-regional:
  actions:
  - invoke-lambda
  - invoke-sfn
  - notify
  - post-finding
  - post-item
  - put-metric
  - webhook
  filters:
  - config-compliance
  - event
  - finding
  - json-diff
  - metrics
  - ops-item
  - value



aws.workspaces:
  actions:
  - auto-tag-user
  - copy-related-tag
  - invoke-lambda
  - invoke-sfn
  - mark-for-op
  - notify
  - post-finding
  - post-item
  - put-metric
  - remove-tag
  - tag
  - webhook
  filters:
  - connection-status
  - event
  - finding
  - marked-for-op
  - metrics
  - ops-item
  - tag-count
  - value



azure.aks:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.api-management:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - resize
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.appserviceplan:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - resize-plan
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.armresource:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - resource-type
  - value




azure.batch:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.cdnprofile:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value




azure.cognitiveservice:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value




azure.container-group:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value




azure.containerregistry:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.containerservice:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.cosmosdb:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - set-firewall-rules
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - firewall-bypass
  - firewall-rules
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.cosmosdb-collection:
  actions:
  - logic-app
  - notify
  - replace-offer
  - restore-throughput-state
  - save-throughput-state
  - webhook
  filters:
  - event
  - metric
  - offer
  - parent
  - value


azure.cosmosdb-database:
  actions:
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - metric
  - offer
  - parent
  - value


azure.cost-management-export:
  actions:
  - execute
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - last-execution
  - value


azure.databricks:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.datafactory:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.datalake:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.disk:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.dnszone:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.eventhub:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - firewall-rules
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.eventsubscription:
  actions:
  - delete
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - value



azure.hdinsight:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - resize
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.image:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.iothub:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.keyvault:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - update-access-policy
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - firewall-bypass
  - firewall-rules
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value
  - whitelist


azure.keyvault-certificate:
  actions:
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - parent
  - value


azure.keyvault-key:
  actions:
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - key-type
  - keyvault
  - parent
  - value


azure.keyvault-storage:
  actions:
  - logic-app
  - notify
  - regenerate-key
  - update
  - webhook
  filters:
  - active-key-name
  - auto-regenerate-key
  - event
  - parent
  - regeneration-period
  - value


azure.loadbalancer:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - frontend-public-ip
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.networkinterface:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - effective-route-table
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.networksecuritygroup:
  actions:
  - auto-tag-date
  - auto-tag-user
  - close
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - open
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - egress
  - event
  - ingress
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.policyassignments:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.postgresql-database:
  actions:
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - parent
  - value



azure.postgresql-server:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.publicip:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.recordset:
  actions:
  - delete
  - lock
  - logic-app
  - notify
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - metric
  - offhour
  - onhour
  - parent
  - policy-compliant
  - resource-lock
  - value


azure.redis:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.resourcegroup:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - empty-group
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value



azure.roleassignment:
  actions:
  - delete
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - resource-access
  - role
  - scope
  - value


azure.roledefinition:
  actions:
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - value


azure.routetable:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.search:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.sql-database:
  actions:
  - delete
  - lock
  - logic-app
  - notify
  - resize
  - update-long-term-backup-retention-policy
  - update-short-term-backup-retention-policy
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - long-term-backup-retention-policy
  - metric
  - offhour
  - onhour
  - parent
  - policy-compliant
  - resource-lock
  - short-term-backup-retention-policy
  - value


azure.sql-server:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - set-firewall-rules
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - firewall-bypass
  - firewall-rules
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.storage:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - require-secure-transfer
  - set-firewall-rules
  - set-log-settings
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - event
  - firewall-bypass
  - firewall-rules
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - storage-diagnostic-settings
  - value


azure.storage-container:
  actions:
  - logic-app
  - notify
  - set-public-access
  - webhook
  filters:
  - event
  - parent
  - value


azure.subscription:
  actions:
  - add-policy
  - logic-app
  - notify
  - webhook
  filters:
  - event
  - missing
  - value


azure.vm:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - poweroff
  - restart
  - start
  - stop
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - event
  - instance-view
  - marked-for-op
  - metric
  - network-interface
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.vmss:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.vnet:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


azure.webapp:
  actions:
  - auto-tag-date
  - auto-tag-user
  - delete
  - lock
  - logic-app
  - mark-for-op
  - notify
  - tag
  - tag-trim
  - untag
  - webhook
  filters:
  - configuration
  - cost
  - diagnostic-settings
  - event
  - marked-for-op
  - metric
  - offhour
  - onhour
  - policy-compliant
  - resource-lock
  - value


gcp.app-engine:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.app-engine-certificate:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.app-engine-domain:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.app-engine-domain-mapping:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.app-engine-firewall-ingress-rule:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.autoscaler:
  actions:
  - notify
  - post-finding
  - set
  - webhook
  filters:
  - event
  - value



gcp.bq-dataset:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value


gcp.bq-job:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.bq-project:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value
 

gcp.bq-table:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.bucket:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.build:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.cloudbilling-account:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value


gcp.dataflow-job:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.disk:
  actions:
  - delete
  - mark-for-op
  - notify
  - post-finding
  - set-labels
  - snapshot
  - webhook
  filters:
  - event
  - marked-for-op
  - value



gcp.dm-deployment:
  actions:
  - delete
  - notify
  - webhook
  filters:
  - event
  - value



gcp.dns-managed-zone:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value

 

gcp.dns-policy:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value

  

gcp.firewall:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.folder:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.function:
  actions:
  - delete
  - notify
  - webhook
  filters:
  - event
  - value


gcp.gke-cluster:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.gke-nodepool:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.iam-role:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.image:
  actions:
  - delete
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.instance:
  actions:
  - delete
  - mark-for-op
  - notify
  - post-finding
  - set-labels
  - start
  - stop
  - webhook
  filters:
  - event
  - marked-for-op
  - offhour
  - onhour
  - value


gcp.instance-template:
  actions:
  - delete
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

  

gcp.interconnect:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.interconnect-attachment:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.kms-cryptokey:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.kms-cryptokey-version:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.kms-keyring:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value

 

gcp.loadbalancer-address:
  actions:
  - delete
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value
 

gcp.loadbalancer-backend-bucket:
  actions:
  - delete
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

 

gcp.loadbalancer-backend-service:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

  

gcp.loadbalancer-forwarding-rule:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

  

gcp.loadbalancer-global-address:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

 

gcp.loadbalancer-global-forwarding-rule:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

  

gcp.loadbalancer-health-check:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value
 

gcp.loadbalancer-http-health-check:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

 

gcp.loadbalancer-https-health-check:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.loadbalancer-ssl-certificate:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

  

gcp.loadbalancer-ssl-policy:
  actions:
  - delete
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.loadbalancer-target-http-proxy:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.loadbalancer-target-https-proxy:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.loadbalancer-target-instance:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.loadbalancer-target-pool:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.loadbalancer-target-ssl-proxy:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.loadbalancer-target-tcp-proxy:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value

 

gcp.loadbalancer-url-map:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.log-exclusion:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.log-project-metric:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.log-project-sink:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.logsink:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.ml-job:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.ml-model:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.organization:
  actions:
  - notify
  - post-finding
  - set-iam-policy
  - webhook
  filters:
  - event
  - value



gcp.project:
  actions:
  - notify
  - post-finding
  - set-iam-policy
  - webhook
  filters:
  - event
  - value



gcp.project-role:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.pubsub-snapshot:
  actions:
  - delete
  - notify
  - webhook
  filters:
  - event
  - value



gcp.pubsub-subscription:
  actions:
  - delete
  - notify
  - webhook
  filters:
  - event
  - value



gcp.pubsub-topic:
  actions:
  - delete
  - notify
  - webhook
  filters:
  - event
  - value



gcp.route:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value


gcp.router:
  actions:
  - delete
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.service:
  actions:
  - disable
  - notify
  - webhook
  filters:
  - event
  - value



gcp.service-account:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.snapshot:
  actions:
  - delete
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



gcp.sourcerepo:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value


gcp.spanner-database-instance:
  actions:
  - delete
  - notify
  - set-iam-policy
  - webhook
  filters:
  - event
  - value



gcp.spanner-instance:
  actions:
  - delete
  - mark-for-op
  - notify
  - set
  - set-iam-policy
  - set-labels
  - webhook
  filters:
  - event
  - marked-for-op
  - value



gcp.sql-backup-run:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.sql-instance:
  actions:
  - delete
  - notify
  - stop
  - webhook
  filters:
  - event
  - value



gcp.sql-ssl-cert:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.sql-user:
  actions:
  - notify
  - webhook
  filters:
  - event
  - value



gcp.subnet:
  actions:
  - notify
  - post-finding
  - set-flow-log
  - set-gcp-private
  - webhook
  filters:
  - event
  - value



gcp.vpc:
  actions:
  - notify
  - post-finding
  - webhook
  filters:
  - event
  - value



k8s.config-map:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.custom-cluster-resource:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.custom-namespaced-resource:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.daemon-set:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.deployment:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.namespace:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.node:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.pod:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.replica-set:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.replication-controller:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.secret:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.service:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.service-account:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.stateful-set:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.volume:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value



k8s.volume-claim:
  actions:
  - delete
  - label
  - notify
  - patch
  - webhook
  filters:
  - event
  - value
```

</details>