## Overview

* Cognito user pool configuration for login.gov SAML IdP

Please note that this module is experimental and thus not enabled by default. This code comes with [technical notes](https://docs.google.com/document/d/1qhulMoqbkpZuT_wasosJQkcBgrnwntLuz2SYJWzcklw/edit?usp=sharing) and an overall [analysis](https://docs.google.com/document/d/1nO0UIbi3DCkSVDUTLblKIEPmnJJt8Vt-A00w4QSYTmQ/edit?usp=sharing) (please note that access is restricted to GSA personnel).

## How to execute

    terraform plan -target=aws_cognito_user_pool_domain.login-dot-gov-domain -target=aws_cognito_user_pool.login-dot-gov -target=aws_cognito_identity_provider.login-dot-gov-idp -target=aws_cognito_user_pool_client.login-dot-gov-client

The above command configures an user pool, a domain and a client configured with a login.gov IdP.

## How to use

The entry point is Cognito, and not login.gov, via the user pool domain:

    https://<your-cognito-app-domain>.auth.us-east-1.amazoncognito.com/login

Three query parameters need to be supplied:

- `response_type`
  - The Oauth 2.0 flow type.
  - Can be either `code` for authorization code grant or `token` for implicit grant.
- `client_id`
  - The Cognito client id that is configured with the login.gov IdP.
- `redirect_uri`
  - One of the Cognito client redirect uris.

Once authenticating via login.gov is successful, Cognito will redirect to the callback url (for more on this, see below).

## Open work

Please note that this configuration is a work in progress and requires some changes to the login.gov end. We have some open work labeled as `TODO` in the code. In particular, after the login.gov changes are in, we need to:

- [ ] set up a real callback url in the user pool client
- [ ] set up an attribute mapping for email in the user pool client IdP configuration
- [ ] test single-logout flow

## Variables

Some variables are required and do not have default values. Those variables must be filled in by you. Otherwise, you can accept the default values if they meet your needs.

| Variable          | Description                     | Required | Initial value               |
|-------------------|---------------------------------|----------|-----------------------------|
| env               | App Environment                 | Yes      | sandbox                     |
| login_gov_idp_url | login.gov Identity Provider URL | Yes      | idp.int.identitysandbox.gov |
