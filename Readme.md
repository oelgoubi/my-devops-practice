# Create local cluster with kind
- kind create cluster --name devops
- k ctx devops 

# Install argocd agent 
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# access ArgoCD UI
kubectl get svc -n argocd
kubectl port-forward svc/argocd-server 8080:443 -n argocd

# login with admin user and below token (as in documentation):
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo


# If we want to remove the delay that argocd make to sync the cluster we can add a webhook to notify argocd about changes to the git repository

## Access thE Nginx server locally on port 9000
kubectl port-forward svc/myapp-service 9000:8080