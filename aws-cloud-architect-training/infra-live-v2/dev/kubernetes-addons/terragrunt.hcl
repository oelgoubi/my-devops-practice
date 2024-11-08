terraform {
  source = "../../../infra-modules/kubernetes-addons"
}

include "root" {
  # Include the root terragrunt.hcl file from the parent folder
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
  merge_strategy = "no_merge"
}


inputs = {
  env = include.env.locals.env
  openid_provider_arn = dependency.eks.outputs.oidc_provider_arn
  eks_name = dependency.eks.outputs.cluster_name
  aws_region = include.env.locals.aws_region
  cluster_autoscaler_helm_version = "9.43.0"
  enable_cluster_autoscaler = true
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.eu-west-3.amazonaws.com/id/12345678901234567890"
    cluster_name = "dev"
  }
}
# Generate the helm provider configuration ( We can't pass variables to the helm provider )
# Variables can be used only from the module
generate "helm_provider" {
  path = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster" "eks" {
    name = var.eks_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
      command     = "aws"
    }
  }
}
EOF
}
