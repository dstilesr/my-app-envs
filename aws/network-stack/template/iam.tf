data "aws_eks_cluster" "main" {
  name = var.eks_cluster_name
}

data "aws_iam_openid_connect_provider" "main" {
  url = data.aws_eks_cluster.main.identity[0].oidc[0]["issuer"]
}

resource "aws_iam_policy" "lbc" {
  name        = "${var.project}-${var.component}-lbc"
  policy      = file("${path.module}/lbc-iam-policy.json")
  description = "Policy for Load Balancer Controller"
}

resource "kubernetes_service_account_v1" "lbc" {
  metadata {
    name      = local.lbc_service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lbc.arn
    }
  }
}

locals {
  dns_service_account_name = "external-dns"
  lbc_service_account_name = "${var.project}-${var.component}-lbc-sa"
  oidc_issuer              = replace(data.aws_iam_openid_connect_provider.main.url, "https://", "")
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResources"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["route53:ListHostedZones"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dns" {
  policy      = data.aws_iam_policy_document.external_dns.json
  name        = "${var.project}-${var.component}-dns"
  description = "Policy for External DNS Controller"
}

resource "aws_iam_role" "dns" {
  name        = "${var.project}-${var.component}-dns"
  description = "IAM Role for External DNS Controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = data.aws_iam_openid_connect_provider.main.arn }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_issuer}:aud" = "sts.amazonaws.com"
            "${local.oidc_issuer}:sub" = "system:serviceaccount:${var.namespace}:${local.dns_service_account_name}"
          }
        }
    }]
  })
}

resource "aws_iam_role" "lbc" {
  name        = "${var.project}-${var.component}-lbc"
  description = "IAM Role for Load Balancer Controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = data.aws_iam_openid_connect_provider.main.arn }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_issuer}:aud" = "sts.amazonaws.com"
            "${local.oidc_issuer}:sub" = "system:serviceaccount:${var.namespace}:${local.lbc_service_account_name}"
          }
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lbc" {
  policy_arn = aws_iam_policy.lbc.arn
  role       = aws_iam_role.lbc.name
}

resource "aws_iam_role_policy_attachment" "dns" {
  role       = aws_iam_role.dns.name
  policy_arn = aws_iam_policy.dns.arn
}
