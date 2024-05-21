variable "aws_profile" {
  type    = string
  default = "myadmin-aws-account"
}

variable "cluster_name" {
  type    = string
  default = "main"
}


variable "aws_account_id" {
  description = "account id number"
  default     = "798277392436"
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default     = "us-east-1"
}
variable "aws_az1_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default     = "us-east-1a"
}

variable "aws_az2_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default     = "us-east-1b"
}


variable "external_dns_chart_version" {
  description = "External-dns Helm chart version to deploy. 3.0.0 is the minimum version for this function"
  type        = string
  default     = "3.0.0"
}



variable "external_dns_chart_log_level" {
  description = "External-dns Helm chart log leve. Possible values are: panic, debug, info, warn, error, fatal"
  type        = string
  default     = "warn"
}

variable "external_dns_zoneType" {
  description = "External-dns Helm chart AWS DNS zone type (public, private or empty for both)"
  type        = string
  default     = ""
}
