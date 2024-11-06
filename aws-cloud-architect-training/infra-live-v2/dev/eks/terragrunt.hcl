terraform {
    source = "../../../infra-modules/eks"
}

# Include the root terragrunt.hcl file to generate the backend.tf and provider.tf files
include "root" {
  path = find_in_parent_folders()
}

inputs = {
  env = "dev"
  cluster_name = "demo"
  eks_version = "1.28"

  # Attach the private subnet IDs from the VPC module
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  node_groups = {
    general = {
      capacity_type = "ON_DEMAND"
      instance_types = ["t3a.xlarge"]
      
      scaling_config = {
        min_size = 0
        max_size = 3
        desired_size = 1
      }
    }
  }

  # Enable IRSA for the EKS cluster
  enable_irsa = true
}


dependency "vpc" {
  config_path = "../vpc"

  # Mock the outputs to make plan command work
  mock_outputs = {
    private_subnet_ids = ["subnet-1234567890abcdef0", "subnet-abcdef01234567890", "subnet-0123456789abcdef0"]
  }
}