provider "helm" {
  # Connect to Kubentetes cluster by getting a token using aws cli
  kubernetes {
    host                   = aws_eks_cluster.compute.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.compute.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--profile", "myadmin-aws-account", "--cluster-name", aws_eks_cluster.compute.id]
      command     = "aws"

    }
  }
}


# Deploy the helm chart for the AWS Load Balancer Controller
resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.1"
  # Set the cluster name and the tag for the AWS Load Balancer Controller
  set {
    name  = "clusterName"
    value = aws_eks_cluster.compute.id
  }

  set {
    name  = "image.tag"
    value = "v2.4.2"
  }
  # Attach the service account to the helm chart because this SA has the necessary permissions to manage the AWS resources
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  # Set the role ARN for the AWS Load Balancer Controller ServiceAccount 
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  depends_on = [
    aws_eks_node_group.private-nodes,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
  ]
}


# resource "helm_release" "external_dns" {
#   name       = "external-dns"
#   namespace  = kubernetes_service_account.external_dns.metadata.0.namespace
#   wait       = true
#   repository = "https://artifacthub.io/packages/helm/bitnami/external-dns"
#   chart      = "external-dns"
#   version    = var.external_dns_chart_version

#   set {
#     name  = "rbac.create"
#     value = false
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = false
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = kubernetes_service_account.external_dns.metadata.0.name
#   }

#   set {
#     name  = "rbac.pspEnabled"
#     value = false
#   }

#   set {
#     name  = "name"
#     value = "${var.cluster_name}-external-dns"
#   }

#   set {
#     name  = "provider"
#     value = "aws"
#   }

# set {
#     name  = "policy"
#     value = "sync"
#   }

#   set {
#     name  = "logLevel"
#     value = var.external_dns_chart_log_level
#   }

#   set {
#     name  = "sources"
#     value = "{ingress,service}"
#   }


#   set{
#     name  = "aws.zoneType"
#     value = var.external_dns_zoneType
#   }

#   set{
#     name  = "aws.region"
#     value = var.aws_region
#   }
# }

# resource "helm_release" "external_dns" {
#   name       = "external-dns"
#   namespace  = kubernetes_service_account.external_dns.metadata.0.namespace
#   wait       = true
#   repository = "https://artifacthub.io/packages/helm/bitnami/external-dns"
#   chart      = "external-dns"
#   version    = var.external_dns_chart_version

#   set {
#     name  = "rbac.create"
#     value = false
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = false
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = kubernetes_service_account.external_dns.metadata.0.name
#   }

#   set {
#     name  = "rbac.pspEnabled"
#     value = false
#   }

#   set {
#     name  = "name"
#     value = "${var.cluster_name}-external-dns"
#   }

#   set {
#     name  = "provider"
#     value = "aws"
#   }

# set {
#     name  = "policy"
#     value = "sync"
#   }

#   set {
#     name  = "logLevel"
#     value = var.external_dns_chart_log_level
#   }

#   set {
#     name  = "sources"
#     value = "{ingress,service}"
#   }


#   set{
#     name  = "aws.zoneType"
#     value = var.external_dns_zoneType
#   }

#   set{
#     name  = "aws.region"
#     value = var.aws_region
#   }
# }