terraform {

  backend "s3" {
    bucket         = "devops-directive-tf-state-othmane"
    key            = "playground/eks-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
    access_key     = "" # Access key and Secret key for the user that has permissions
    secret_key     = ""
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile
}
