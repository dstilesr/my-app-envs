
resource "aws_eks_addon" "addons" {
  for_each             = var.addons
  addon_name           = each.value.addon_name
  cluster_name         = aws_eks_cluster.main.name
  configuration_values = each.value.configuration_values

  timeouts {
    create = "12m"
    update = "12m"
    delete = "20m"
  }
}
