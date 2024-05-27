output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.compute.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.compute.certificate_authority[0].data
}