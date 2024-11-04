# Show terraform providers
- terraform providers
# show output of terraform state file
- tf output -json

# starts an interactive console to type interpolation (string templating) to inspect values
- tf console

# After creating eks cluster, you need to create a kubeconfig file to use kubectl to interact with the cluster
- aws eks --region <region> update-kubeconfig --name <cluster-name> --profile <profile-name>
