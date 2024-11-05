

# EKS (Elastic Kubernetes Service)
## Objective
The objective of this module is to create a fully functional EKS cluster with a specified number of node groups. Each node group will have a defined capacity type, instance types, scaling configuration, and update configuration.


# IRSA (IAM Role for Service Accounts)
## Example Scenario
Imagine you have a Kubernetes application running on EKS that needs to access an S3 bucket. By setting up IRSA, you can create a service account in Kubernetes that is linked to an IAM role with permissions to access the S3 bucket. This setup allows your application to securely access AWS resources without needing to manage AWS credentials directly in your application code.
