variable "kubeconfig_path" {
    description = "Path to the kubeconfig file"
    type        = string
    default     = "~/.kube/config"
}

variable "kubeconfig_context" {
    description = "Context to use in the kubeconfig file"
    type        = string
    default     = "kind-devops"
}