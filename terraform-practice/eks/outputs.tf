output "endpoint" {
  value = aws_eks_cluster.compute.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.compute.certificate_authority[0].data
}