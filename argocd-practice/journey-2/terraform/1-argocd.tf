# install argocd directly 
# helm install argocd -n argocd --create-namespace argo/argo-cd --version 3.35.4 -f terraform/values/argocd.yaml

# Use helm provider to install argocd in my local k8s cluster
resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd" # chartName can be found using helm search repo argo-cd
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4" # chartVersion

  values = [file("values/argocd.yaml")] # values file to override default values
}

# Get the initial admin password
resource "null_resource" "password" {
  provisioner "local-exec" {
    command     = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }
}