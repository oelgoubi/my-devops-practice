# Use helm provider to install argocd in my local k8s cluster
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
    config_context = var.kubeconfig_context
  }
}

# In case, we are using EKS, we can use the following snippet: cluserName = demo
# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.demo.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.demo.id]
#       command     = "aws"
#     }
#   }
# }