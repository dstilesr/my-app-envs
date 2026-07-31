resource "helm_release" "external_dns" {
  chart            = "external-dns"
  name             = "external-dns"
  namespace        = var.namespace
  atomic           = true
  create_namespace = false
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  upgrade_install  = true
  version          = var.external_dns_version

  values = [yamlencode({
    provider = {
      name = "aws"
    }
    env = [
      {
        name  = "AWS_DEFAULT_REGION"
        value = var.region
      }
    ]
    serviceAccount = {
      create = true
      name   = local.dns_service_account_name

      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.dns.arn
      }
    }
    sources = var.external_dns_sources
  })]

  depends_on = [aws_iam_role_policy_attachment.dns]
}
