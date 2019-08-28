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
* IDP Connect Providers (in progress)

## Variables

Some variables are required and do not have default values. Those variables must be filled in by you. Otherwise, you can accept the default values if they meet your needs.

| Variable       | Description           | Required | Initial value               |
|----------------|-----------------------|----------|-----------------------------|
| env            | App Environment       | Yes      | sandbox                     |
| aws_account_id | AWS Account ID        | Yes      |                             |
| idp_url        | Identity Provider URL | Yes      | idp.int.identitysandbox.gov |

### OpenID Connect Notes

Obtaining the thumbprint is a manual process. More details at the [AWS documentation on obtaining Root CA Thumbprint](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html "AWS documentation on obtaining Root CA Thumbprint"). Fortunately, we only need to do this once per OIDC IDP.

TL;DR:

    $ curl -s -X GET https://idp.int.identitysandbox.gov/.well-known/openid-configuration | jq ".jwks_uri" | cut -d/ -f 3
    $ openssl s_client -servername idp.int.identitysandbox.gov -showcerts -connect idp.int.identitysandbox.gov:443
    ... (copy and paste last certificate) ...
    $ openssl x509 -in certificate.crt -fingerprint -noout | tr -d :

### SAML Notes

To obtain the SAML metadata (adjust for date)

    $ curl -X GET -s https://idp.int.identitysandbox.gov/api/saml/metadata2019
