
````
```
Goals: 
- Deploy ArgoCD with terraform in k8s Cluser 
- Configure ArgoCD Agent to sync changes from a private git repository

In order to allow ArgoCD to access our private git repository, we can use SSH keys.
# Generate the SSH key-pair
ssh-keygen -t ed25519 -C <email-address> -f ~/.ssh/argocd-github-perso

# Add the public key as a DEPLOY KEY to the Git repository wa want to target
cat ~/.ssh/argocd-github-perso.pub

# Assign only Read permissions to the Deployed KEY

# Create a K8S Secret and embed the value of the private SSH key in it 
Like showed in the file : argocd-config/git-repo-secret.yaml

# Apply that secret and then apply the argo App 
kubectl apply -f argocd-config/git-repo-secret.yaml
kubectl apply - argscd-config/myapp-2.yaml



```
````
