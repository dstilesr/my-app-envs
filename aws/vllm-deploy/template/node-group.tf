
resource "aws_eks_node_group" "gpu" {
  cluster_name    = data.terraform_remote_state.cluster.outputs.cluster_name
  node_group_name = "${var.project}-gpu-node-group"
  node_role_arn   = data.terraform_remote_state.cluster.outputs.node_role_arn
  subnet_ids      = var.gpu_node_subnets
  instance_types  = var.gpu_node_instance_types
  ami_type        = var.gpu_node_ami_type
  capacity_type   = var.gpu_node_capacity_type
  disk_size       = var.gpu_node_disk_size

  scaling_config {
    desired_size = var.gpu_node_desired_size
    min_size     = var.gpu_node_min_size
    max_size     = var.gpu_node_max_size
  }

  labels = merge(var.gpu_node_labels, {
    workload       = "gpu"
    node_group_key = "gpu"
  })

  dynamic "taint" {
    for_each = var.gpu_node_taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  timeouts {
    create = "18m"
    update = "18m"
  }
}
