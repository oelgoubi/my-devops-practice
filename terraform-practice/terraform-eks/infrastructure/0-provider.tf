terraform {
required_version = ">= 1.0.0"
backend "s3" {
bucket         = "devops-directive-tf-state-othmane"
key            = "playground/eks-cluster/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locking"
encrypt        = true
}
required_providers {
aws = {
source  = "hashicorp/aws"
version = "~> 3.0" # only the rightmost version number can be changed
}

helm = {
  source  = "hashicorp/helm"
  version = "= 2.5.1"
}

kubectl = {
  source  = "gavinbunney/kubectl"
  version = ">= 1.14.0"
}

}
}

provider "aws" {
region  = "us-east-1"
profile = var.aws_profile
}

provider "helm" {
kubernetes {
config_path = "~/.kube/demo-eks"
}
}