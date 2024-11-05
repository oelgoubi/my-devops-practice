resource "aws_eks_node_group" "eks_nodes" {
    for_each = var.node_groups

    # specify the cluster name
    cluster_name    = aws_eks_cluster.this.name
    # specify the node group name
    node_group_name = each.key

    # specify the node role ARN
    node_role_arn   = aws_iam_role.eks_nodes_role.arn
    # specify the subnet IDs to spin up the nodes in
    subnet_ids      = var.subnet_ids

    # specify the capacity type (SPOT or ON_DEMAND)
    capacity_type = each.value.capacity_type
    # specify the instance types (e.g. t3.medium, t3.large, etc.)
    instance_types = each.value.instance_types

    # specify the initial & maximum & desired number of nodes
    scaling_config {
        min_size     = each.value.min_size
        max_size     = each.value.max_size
        desired_size = each.value.desired_size
    }

    update_config {
        max_unavailable = 1
    }

    labels = {
        role = each.key
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_nodes_role_policy
    ]

}   