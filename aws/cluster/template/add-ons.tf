
locals {
  ebs_addon_key = try(one([for k, v in var.addons : k if v.addon_name == "aws-ebs-csi-driver"]), null)

  addon_irsa_roles = {
    for k in keys(var.addons) : k => (
      k == local.ebs_addon_key ? try(aws_iam_role.ebs_csi[0].arn, null) : null
    )
  }
}

resource "aws_eks_addon" "addons" {
  for_each                 = var.addons
  addon_name               = each.value.addon_name
  cluster_name             = aws_eks_cluster.main.name
  configuration_values     = each.value.configuration_values
  service_account_role_arn = local.addon_irsa_roles[each.key] != null ? local.addon_irsa_roles[each.key] : each.value.service_account_role_arn

  timeouts {
    create = "15m"
    update = "15m"
    delete = "20m"
  }
}
