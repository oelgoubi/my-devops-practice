variable "env" {
  description = "The environment name"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  type        = string
}

variable "endpoint_private_access" {
  description = "Whether the EKS cluster should have private access to the API server"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether the EKS cluster should have public access to the API server"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "The subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "node_groups" {
  description = "The EKS node groups to create in the EKS cluster"
  type        = map(any)
}

variable "enable_irsa" {
  description = "Whether to enable IRSA"
  type        = bool
  default     = false
}
