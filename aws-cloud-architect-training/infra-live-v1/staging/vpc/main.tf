terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket         = "aws-practice-othmane"
    key            = "aws-practice-othmane/infra-live-v1/staging/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 5.74.0"
    }
  }

}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


module "vpc" {
  source = "../../../infra-modules/vpc"

  env                        = "staging"
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  cidr_block             = var.vpc_cidr_block
  availability_zones = var.availability_zones

  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

}
