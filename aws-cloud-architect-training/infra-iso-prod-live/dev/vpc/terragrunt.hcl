terraform {
    source = "../../../infra-modules/vpc"
}

# Include the root terragrunt.hcl file
include "root" {
  # Find the root terragrunt.hcl file in the current directory and all parent directories
  path = find_in_parent_folders()
}

inputs = {
    env = "dev"
    availability_zones = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
    public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]  
    
    # Warning: these tags are used by the EKS module to identify the subnets
    public_subnet_tags = {
    "kubernetes.io/cluster/dev-demo" = "owned"
    "kubernetes.io/role/elb" = "1"
    }
    private_subnet_tags = {
    "kubernetes.io/cluster/dev-demo" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
    }
}