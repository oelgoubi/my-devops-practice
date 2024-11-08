variable "env" {
  description = "The environment name"
  type        = string
}

variable "openid_provider_arn" {
  description = "The ARN of the OpenID Connect provider for the cluster"
  type        = string
}

variable "eks_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "The region of the EKS cluster"
  type        = string
}

variable "cluster_autoscaler_helm_version" {
  description = "The version of the cluster autoscaler helm chart"
  type        = string
}

variable "enable_cluster_autoscaler" {
  description = "Whether to enable the cluster autoscaler"
  type        = bool
}
