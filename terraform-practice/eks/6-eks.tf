# Kubernetes clusters managed by Amazon EKS make calls to other AWS services on your behalf to manage the resources that you use with the service. 
# For example, EKS will create an autoscaling group for each instance group if you use managed nodes. 

# Create IAM role 
resource "aws_iam_role" "eks-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
# Attach required IAM policy to the role eks-cluster-role
resource "aws_iam_role_policy_attachment" "eks-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name
}


# create the EKS cluster
resource "aws_eks_cluster" "compute" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]
  }

  # Make sure to create IAM role with AmazonEKSClusterPolicy first
  depends_on = [aws_iam_role_policy_attachment.eks-role-AmazonEKSClusterPolicy]
}