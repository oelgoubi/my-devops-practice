resource "aws_iam_role" "eks_nodes_role" {
    name = "${var.env}-${var.cluster_name}-eks-nodes"

    # The policy that allows EKS Service to manage the nodes
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
    }]
    })
}

# Attach dynamically the IAM policies to the EKS nodes role
resource "aws_iam_role_policy_attachment" "eks_nodes_role_policy" {
    for_each = var.node_iam_policies

    policy_arn = each.value
    role       = aws_iam_role.eks_nodes_role.name
}