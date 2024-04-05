
# Access ArgoCD UI
    $ k port-forward svc/argocd-server 9000:80 -n argocd

# Delete Argocd Application with kubectl 
- non-cascade delete
    $ kubectl patch app $APPNAME  -n argocd -p '{"metadata": {"finalizers": null}}' --type merge 
    $ kubectl -n argocd delete app $APPNAME
- Cascading delete
$ kubectl patch app $APPNAME  -n argocd -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}' --type merge 
$ kubectl -n argocd delete app $APPNAME