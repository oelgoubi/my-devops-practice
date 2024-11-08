## IRSA (IAM Role for Service Accounts)
# Create an IAM OIDC provider for the EKS cluster
#Objective: The code sets up a connection between your EKS cluster and AWS IAM using OIDC. 
# This allows Kubernetes service accounts to assume IAM roles, enabling them to access AWS resources securely.

# Fetch the TLS certificate for the EKS cluster's OIDC issuer
data "tls_certificate" "this" {
    url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# Create an IAM OIDC provider ( Trusted Entity ) for the EKS cluster
# This allows AWS to trust identities from the EKS cluster
resource "aws_iam_openid_connect_provider" "this" {
    count = var.enable_irsa ? 1 : 0
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
    url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
