# To manage permissions for your applications that you deploy in Kubernetes. 
# You can either attach policies to Kubernetes nodes directly. In that case, every pod will get the same access to AWS resources. Or you can create OpenID connect provider,
# which will allow granting IAM permissions based on the serviceaccount used by the pod

data "tls_certificate" "eks" {
  url = aws_eks_cluster.compute.identity[0].oidc[0].issuer
}
# create the OpenID Connect provider
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.compute.identity[0].oidc[0].issuer
}

#  testing the provider first before deploying the autoscaller is highly recommended -> 9-iam-test.tf