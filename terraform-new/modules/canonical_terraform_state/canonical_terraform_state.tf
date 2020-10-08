# Define the S3 buckets for terraform state tracking
resource "aws_dynamodb_table" "tf-lock-table-gitrepos" {
  for_each              = toset( var.tfstate_managed_repositories )

  name                              = "${var.tfstate_table_name_prefix}-dynamodb-${each.key}"
  read_capacity                     = 2
  write_capacity                    = 1
  hash_key                          = "LockID"

  attribute {
    name                                = "LockID"
    type                                = "S"
  }

  server_side_encryption {
    enabled                             = true
  }

  lifecycle {
    prevent_destroy                     = true
  }
}
