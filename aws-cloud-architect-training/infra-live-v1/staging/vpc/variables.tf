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

variable "availability_zones" {
  description = "The availability zones to deploy the resources"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["172.31.1.0/24", "172.31.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["172.31.101.0/24", "172.31.102.0/24"]
}

variable "public_subnet_tags" {
  description = "The tags for the public subnets"
  type        = map(string)
  default = {
    "kubernetes.io/cluster/my-eks-cluster" = "owned"
    "kubernetes.io/role/elb"               = "1"
  }
}

variable "private_subnet_tags" {
  description = "The tags for the private subnets"
  type        = map(string)
  default = {
    "kubernetes.io/cluster/my-eks-cluster" = "owned"
    "kubernetes.io/role/internal-elb"      = "1"
  }
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.31.0.0/16"
}

# variable "bucket_name" {
#   description = "The name of the bucket to store the terraform state"
#   type        = string
#   default     = "aws-practice-othmane"
# }

# variable "dynamodb_table_name" {
#   description = "The name of the dynamodb table to store the terraform state lock"
#   type        = string
#   default     = "terraform-state-locking"
# }