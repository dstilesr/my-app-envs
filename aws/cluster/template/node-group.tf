
resource "aws_eks_node_group" "main_groups" {
  for_each        = var.node_groups
  subnet_ids      = each.value.subnets
  cluster_name    = aws_eks_cluster.main.name
  instance_types  = each.value.instance_types
  ami_type        = each.value.ami_type
  node_group_name = "${var.project}-${each.key}-node-group"
  node_role_arn   = aws_iam_role.nodes.arn
  capacity_type   = each.value.capacity_type

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  labels = {
    node_group_key = each.key
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
