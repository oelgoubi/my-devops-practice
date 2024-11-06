### Remote State Configuration can be used across multiple terragrunt projects ###

# Backend configuration
remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "aws-practice-othmane"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-west-3"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

# Provider configuration
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "eu-west-3"
  profile = "myadmin-aws-account"
}
EOF
}