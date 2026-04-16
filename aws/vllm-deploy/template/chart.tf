resource "helm_release" "vllm" {
  chart     = "../../../vllm-deployment"
  atomic    = true
  name      = var.project
  namespace = kubernetes_namespace.vllm.metadata.name
  set = [
    {
      name  = "project"
      value = var.project
    },
    {
      name  = "cloudProvider"
      value = "aws"
    },
    {
      name  = "instanceName"
      value = replace(var.service_llm_path, "/", "-")
    },
    {
      name  = "llm.modelPath"
      value = var.service_llm_path
    },
    {
      name  = "image.repository"
      value = var.service_image
    },
    {
      name  = "image.tag"
      value = var.service_image_tag
    }
  ]
}
