data "aws_eks_cluster" "main" {
  name = var.eks_cluster_name
}

resource "aws_iam_policy" "lbc" {
  name        = "${var.project}-${var.component}-policy"
  policy      = file("${path.module}/lbc-iam-policy.json")
  description = "Policy for Load Balancer Controller"
}

resource "kubernetes_service_account_v1" "lbc" {
  metadata {
    name      = "${var.project}-${var.component}-sa"
    namespace = var.lbc_namespace
  }
}

locals {
  service_account_name = kubernetes_service_account_v1.lbc.metadata[0].name
}

resource "aws_iam_role" "lbc" {
  name        = "${var.project}-${var.component}-role"
  description = "IAM Role for Load Balancer Controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = data.aws_eks_cluster.main.identity[0].oidc[0]["issuer"] }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "$oidc_provider:aud" = "sts.amazonaws.com"
            "$oidc_provider:sub" = "system:serviceaccount:${var.lbc_namespace}:${local.service_account_name}"
          }
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lbc" {
  policy_arn = aws_iam_policy.lbc.arn
  role       = aws_iam_role.lbc.name
}
