resource "kubernetes_namespace_v1" "vllm" {
  metadata {
    name = "vllm"
  }
}
