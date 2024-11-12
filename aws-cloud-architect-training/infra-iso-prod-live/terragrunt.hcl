### Remote State Configuration can be used across multiple terragrunt projects ###

# Backend configuration
remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    profile = "wise"
    role_arn = "arn:aws:iam::798277392436:role/terraform"
    region = "eu-west-3"
    
    bucket = "aws-practice-othmane"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true

    dynamodb_table = "terraform-state-locking"
  }
}

# Provider configuration
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "eu-west-3"
  profile = "wise"
  assume_role {
    role_arn     = "arn:aws:iam::798277392436:role/terraform"
    session_name = "SESSION_NAME"
}

}
EOF
}