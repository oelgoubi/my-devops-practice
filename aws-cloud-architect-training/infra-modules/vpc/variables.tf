variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "env" {
  description = "The environment for the VPC"
  type        = string
  default     = "dev"
}


variable "aws_region" {
  description = "The AWS region for the VPC"
  type        = string
  default     = "eu-west-3"
}

variable "availability_zones" {
  description = "The availability zone for the subnets"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnet_tags" {
  description = "Private subnet tags."
  type        = map(any)
}

variable "public_subnet_tags" {
  description = "Private subnet tags."
  type        = map(any)
}