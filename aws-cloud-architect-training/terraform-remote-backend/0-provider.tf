terraform {
required_version = ">= 1.0.0"
backend "s3" {
  bucket         = "aws-practice-othmane"
  key            = "aws-practice-othmane/demo/terraform.tfstate"
  region         = "eu-west-3"
  dynamodb_table = "terraform-state-locking"
  encrypt        = true
}
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 3.0" # only the rightmost version number can be changed
  }
}

}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  shared_credentials_file = "~/.aws/credentials"
}
