# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = "argocd"
#   }
#   depends_on = [ aws_eks_node_group.private-nodes ]
# }

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "3.35.4"
  create_namespace = true
  namespace  = "argocd"
  values     = [file("argocd/values.yaml")]

  depends_on = [ aws_eks_node_group.private-nodes ]
}

resource "null_resource" "password" {
  provisioner "local-exec" {
    working_dir = "./argocd"
    command     = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }
  depends_on = [ helm_release.argocd ]
}

resource "null_resource" "del-argo-pass" {
  depends_on = [null_resource.password]
  provisioner "local-exec" {
    command = "kubectl -n argocd delete secret argocd-initial-admin-secret"
  }
}