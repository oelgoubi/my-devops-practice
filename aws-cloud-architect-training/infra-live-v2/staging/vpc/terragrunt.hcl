terraform {
    source = "../../../infra-modules/vpc"
}

# Include the root terragrunt.hcl file
include "root" {
  # Find the root terragrunt.hcl file in the current directory and all parent directories
  path = find_in_parent_folders()
}

inputs = {
    env = "staging"
    availability_zones = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
    cidr_block = "100.0.0.0/16"
    public_subnet_cidr_blocks = ["100.0.1.0/24", "100.0.2.0/24", "100.0.3.0/24"]
    private_subnet_cidr_blocks = ["100.0.4.0/24", "100.0.5.0/24", "100.0.6.0/24"]  
    
    # Warning: these tags are used by the EKS module to identify the subnets
    public_subnet_tags = {
    "kubernetes.io/cluster/staging-demo" = "owned"
    "kubernetes.io/role/elb" = "1"
    }
    private_subnet_tags = {
    "kubernetes.io/cluster/staging-demo" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
    }
}