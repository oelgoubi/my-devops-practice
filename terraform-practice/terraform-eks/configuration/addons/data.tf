data "terraform_remote_state" "terraform_state" {
  backend = "s3"
  config = {
    bucket = "devops-directive-tf-state-othmane"
    key    = "playground/eks-cluster/addons/terraform.tfstate"
    region = "us-east-1"
  }
}