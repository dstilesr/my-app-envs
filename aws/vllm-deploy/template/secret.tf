data "aws_secretsmanager_secret_version" "hf_token" {
  secret_id = var.remote_hf_token_secret
}

resource "kubernetes_secret_v1" "hf_token" {
  metadata {
    name      = "vllm-hf-token"
    namespace = kubernetes_namespace.vllm.metadata.name
  }
  type = "Opaque"
  data = {
    hf_token = sensitive(data.aws_secretsmanager_secret_version.hf_token.secret_string)
  }
}
