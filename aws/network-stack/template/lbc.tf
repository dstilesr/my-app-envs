resource "helm_release" "lb_controller" {
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = var.namespace
  version          = var.lbc_version
  name             = var.lbc_name
  upgrade_install  = true
  create_namespace = false
  atomic           = true

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
      value = local.lbc_service_account_name
    },
    {
      name  = "vpcId"
      value = data.aws_eks_cluster.main.vpc_config[0].vpc_id
    }
  ]

  depends_on = [aws_iam_role_policy_attachment.lbc, kubernetes_service_account_v1.lbc]
}
