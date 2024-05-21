# To meet the requirements of the EKS cluster, we need to create two public and two private subnets in two different availability zones.
# https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
#1. One private and one public subnet in each availability zone
# We assign a range of 255 IP addresses to each subnet
resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.compute.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.aws_az1_region}"

  # Tags are important and will be used by the ALB Controller to identify the subnets and create private ALBs
  tags = {
    "Name"                                      = "private-us-east-1a"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" # subnet used only by k8s cluster
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.compute.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_az2_region}"

  tags = {
    "Name"                                      = "private-us-east-1b"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-us-east-1a" {
  vpc_id            = aws_vpc.compute.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_az1_region}"

  ## To create Public k8s instances groups
  # map_public_ip_on_launch = true

  # Tags used by the ALB Controller to identify the subnets and create public ALBs 
  tags = {
    "Name"                                      = "public-us-east-1a"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id            = aws_vpc.compute.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_az2_region}"

  ## To create Public k8s instances groups but we don't need it because we will use ALB to expose our cluster
  # map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-us-east-1b"
    "kubernetes.io/role/elb"                    = "1" # this is required and instructs K8S to create public LBs in these subnets
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}