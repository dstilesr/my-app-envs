resource "helm_release" "lb_controller" {
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = var.lbc_namespace
  version          = var.lbc_version
  name             = var.lbc_name
  upgrade_install  = true
  create_namespace = false

  set = [
    {
      name  = "clusterName"
      value = var.eks_cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = false
    },
    {
      name  = "serviceAccount.name"
      value = local.service_account_name
    }
  ]

  depends_on = [aws_iam_role_policy_attachment.lbc]
}

