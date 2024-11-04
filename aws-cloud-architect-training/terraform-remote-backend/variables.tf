variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "eu-west-3"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = "myadmin-aws-account"
}

variable "kube_config_path" {
  description = "The path to the kube config file"
  type        = string
  default     = "~/.kube/demo-eks"
}

variable "bucket_name" {
  description = "The name of the bucket to store the terraform state"
  type        = string
  default     = "aws-practice-othmane"
}

variable "dynamodb_table_name" {
  description = "The name of the dynamodb table to store the terraform state lock"
  type        = string
  default     = "terraform-state-locking"
}