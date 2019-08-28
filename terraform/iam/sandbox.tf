# login.gov openid connect
resource "aws_iam_openid_connect_provider" "login-dot-gov" {
  url = "https://idp.int.identitysandbox.gov"

  client_id_list = [
    "urn:gov:gsa:openidconnect.profiles:sp:sso:opp:aws_authentication",
  ]

  thumbprint_list = [
    "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"
  ]
}

# login.gov saml
resource "aws_iam_saml_provider" "login-dot-gov" {
  name = "idp.int.identitysandbox.gov"
  saml_metadata_document = "${file("files/login-dot-gov-saml.xml")}"
}
