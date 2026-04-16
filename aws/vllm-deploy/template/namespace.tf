resource "kubernetes_namespace" "vllm" {
  metadata {
    name = "vllm"
  }
}
