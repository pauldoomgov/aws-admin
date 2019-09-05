resource "aws_cognito_user_pool" "login-dot-gov" {
  name = "${var.env} login gov pool"

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  username_attributes = [ "email", "phone_number" ]
  # note that auto-verifying a phone number requires a SMS configuration
  auto_verified_attributes = [ "email" ]
}

resource "aws_cognito_user_pool_domain" "login-dot-gov-domain" {
  domain = "login-dot-gov-saml"
  user_pool_id = "${aws_cognito_user_pool.login-dot-gov.id}"
}

resource "aws_cognito_identity_provider" "login-dot-gov-idp" {
  user_pool_id = "${aws_cognito_user_pool.login-dot-gov.id}"
  provider_name = "login-dot-gov-saml"
  provider_type = "SAML"

  provider_details = {
    MetadataURL = "https://${var.login_gov_idp_url}/api/saml/metadata2019"
  }

  attribute_mapping = {
    # TODO
  }

  # TODO sign out flow
}

resource "aws_cognito_user_pool_client" "login-dot-gov-client" {
  name = "SAML client"
  user_pool_id = "${aws_cognito_user_pool.login-dot-gov.id}"

  allowed_oauth_flows = [ "code", "implicit" ]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [ "phone", "email", "openid" ]

  # TODO
  callback_urls = [ "https://gsa.gov" ]
  default_redirect_uri = "https://gsa.gov"

  supported_identity_providers = [
    "${aws_cognito_identity_provider.login-dot-gov-idp.provider_name}"
  ]
}
