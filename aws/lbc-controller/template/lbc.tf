resource "helm_release" "lb_controller" {
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = var.lbc_namespace
  version    = var.lbc_version
  name       = var.lbc_name

  set = [
    {
      name = "clusterName"
      value = var.eks_cluster_name
    },
    {
      name = "serviceAccount.create"
      value = false
    },
    {
      name = "serviceAccount.name"
      value = kubernetes_service_account_v1.lbc.metadata.name
    }
  ]
}

