
# Autoscaler needs to assume a role on AWS to manage the autoscaling group and discover 
# the instances in the group. This is done by creating an IAM policy document that allows
# the service account to assume the role of the autoscaler on AWS.

# 1. Fetch the OpenID Connect provider for the cluster ( Trusted Entity )
data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}
# 2. Define IAM Role Trust Relationship "EKS Cluster -> IAM Role"
# Create an IAM policy document for the cluster autoscaler that allows 
# the service account to assume the role of the autoscaler on AWS
data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
     # Specify which service account can assume this role
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }
    # Trust the OIDC provider
    principals {
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
  }
}

# 3. Create an IAM role for the cluster autoscaler that uses the policy document
resource "aws_iam_role" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler.json
  name               = "${var.eks_name}-cluster-autoscaler"
}

# 4. Define the permissions for the cluster autoscaler
resource "aws_iam_policy" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name = "${var.eks_name}-cluster-autoscaler"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Permissions to view Auto Scaling groups and EC2 instances
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        # Permissions to modify Auto Scaling groups
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# 5. Attach the policy to the role
resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  role       = aws_iam_role.cluster_autoscaler[0].name
  policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
}

# 6. Deploy the cluster autoscaler using Helm
resource "helm_release" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name = "autoscaler"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = var.cluster_autoscaler_helm_version

  # Set the service account name
  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
  
  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  # Annotate the service account with the IAM role ARN
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler[0].arn
  }

  # Configure the cluster name for the cluster autoscaler & auto-discovery
  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_name
  }
}