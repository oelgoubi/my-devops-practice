# Infra Live V2
This is the second version of the infrastructure live using modules (like VPC, EKS, Eks-addons, etc.) and using Terragrunt to manage the infrastructure code across multiple environments (dev, staging).

**N.B.** Some changes might be needed to be done from your local machine to run the project. For example:
- Update the kubeconfig for the EKS cluster in the local machine
- Update the AWS profile to be used in the project

## Steps to run the project on dev environment

```bash
cd aws-cloud-architect-training/infra-live-v2/dev
```

2. Initialize the modules

```bash
terragrunt run-all init
```

3. Plan the changes

```bash
    terragrunt run-all plan
```

4. Apply the changes

```bash
terragrunt run-all apply
```

5. Update the kubeconfig for the EKS cluster in the local machine

```bash
    aws eks --region eu-west-3 update-kubeconfig --name dev-demo --profile $AWS_PROFILE --kubeconfig ~/.kube/demo-eks
```

6. Verify the EKS cluster

```bash
kubectl get nodes --kubeconfig ~/.kube/demo-eks
```
