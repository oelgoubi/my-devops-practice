# # Create a S3 bucket to store the terraform state named devops-directive-tf-state
resource "aws_s3_bucket" "terraform_state" {
  count = length(aws_s3_bucket.terraform_state) == 0 ? 1 : 0
  bucket = "devops-directive-tf-state-othmane"
  lifecycle {
    prevent_destroy = true
  }
}
# Enable versioning for the S3 bucket created previously
resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  count = length(aws_s3_bucket_versioning.terraform_bucket_versioning) == 0 ? 1 : 0
  bucket = aws_s3_bucket.terraform_state[0].id
  versioning_configuration {
    status = "Enabled"
  }
  lifecycle {
    prevent_destroy = true
  }
}
# We Encrypt the S3 bucket using AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  count = length(aws_s3_bucket_server_side_encryption_configuration.terraform_state_crypto_conf) == 0 ? 1 : 0
  bucket = aws_s3_bucket.terraform_state[0].bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}
# We create the dynamodb table to lock the state file
resource "aws_dynamodb_table" "terraform_locks" {
  count = length(aws_dynamodb_table.terraform_locks) == 0 ? 1 : 0
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  lifecycle {
    prevent_destroy = true
  }
}
