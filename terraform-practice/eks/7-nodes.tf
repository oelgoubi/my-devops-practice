# Create a single instance group for Kubernetes. Similar to the EKS cluster, it requires an IAM role as well

resource "aws_iam_role" "eks-worker-nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
# KUBLET in workers makes calls to AWS APIs on your behalf. (GRANTS ACCESS TO EC2 AND EKS)
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker-nodes.name
}

# Attach the policy to the role to allow the nodes to communicate
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-nodes.name
}

# Attach the policy to the role to allow the nodes to fetch the container images from ECR
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-nodes.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.compute.name
  node_group_name = "private-eks-worker-nodes"
  node_role_arn   = aws_iam_role.eks-worker-nodes.arn

  # Launch nodes in the private subnets
  subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
  ]

  # Use On-Demand instances ( we can use spots as well)
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]
  # Additional componenent 'AutoScaller' should be installed to manage autoscalling
  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 0
  }

  # max_unavailable is the number of nodes that can be unavailable during the update
  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  # taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

  # Make sure that the IAM role is created first and Policies are attached
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# resource "aws_launch_template" "eks-with-disks" {
#   name = "eks-with-disks"

#   key_name = "local-provisioner"

#   block_device_mappings {
#     device_name = "/dev/xvdb"

#     ebs {
#       volume_size = 50
#       volume_type = "gp2"
#     }
#   }
# }