# EKS IAM Role 
resource "aws_iam_role" "eks_cluster_role" {
    name = "${var.env}-${var.cluster_name}-eks-cluster"

    # The policy that allows EKS Service to manage the cluster & the nodes
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}

# Attach the Amazon EKS cluster policy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster_role.name
}


# Create the EKS cluster
resource "aws_eks_cluster" "this" {
    name     = "${var.env}-${var.cluster_name}"
    version = var.eks_version

    # The ARN of the IAM role that provides permissions to the EKS cluster
    role_arn = aws_iam_role.eks_cluster_role.arn

    # The VPC configuration for the EKS cluster
    vpc_config {
        # Whether the EKS cluster should have private access to the API server
        endpoint_private_access = var.endpoint_private_access
        # Whether the EKS cluster should have public access to the API server
        endpoint_public_access  = var.endpoint_public_access

        subnet_ids              = var.subnet_ids
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_role_policy
    ]
}
    