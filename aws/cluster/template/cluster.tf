
resource "aws_eks_cluster" "main" {
  name                          = "${var.project}-main-cluster"
  role_arn                      = aws_iam_role.cluster.arn
  version                       = var.kubernetes_version
  bootstrap_self_managed_addons = var.kubernetes_bootstrap_addons

  vpc_config {
    subnet_ids = var.cluster_subnets
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}
