
# Policy that allow the ExternalDns ServiceAccount to assume the IAM role
data "aws_iam_policy_document" "external_dns_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "external_dns" {
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role_policy.json
  name               = "external-dns"
}

resource "aws_iam_policy" "external_dns" {
  policy = file("./ExternalDNSAccess.json")
  name   = "ExternalDNSAccess"
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "external_dns_attach" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}


output "external_dns_role_arn" {
  value = aws_iam_role.external_dns.arn
}

# resource "kubernetes_service_account" "external_dns" {
#   metadata {
#     name      = "external-dns"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
#     }
#   }
#   automount_service_account_token = true
# }

# resource "kubernetes_cluster_role" "external_dns" {
#   metadata {
#     name = "external-dns"
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["services", "pods", "nodes"]
#     verbs      = ["get", "list", "watch"]
#   }
#   rule {
#     api_groups = ["extensions", "networking.k8s.io"]
#     resources  = ["ingresses"]
#     verbs      = ["get", "list", "watch"]
#   }
#   rule {
#     api_groups = ["networking.istio.io"]
#     resources  = ["gateways"]
#     verbs      = ["get", "list", "watch"]
#   }
# }

# resource "kubernetes_cluster_role_binding" "external_dns" {
#   metadata {
#     name = "external-dns"
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.external_dns.metadata.0.name
#   }
#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.external_dns.metadata.0.name
#     namespace = kubernetes_service_account.external_dns.metadata.0.namespace
#   }
# }

