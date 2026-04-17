resource "helm_release" "nvidia_device_plugin" {
  name       = "${var.project}-nvidia-plugin"
  repository = "https://nvidia.github.io/k8s-device-plugin"
  chart      = var.nvidia_plugin_chart
  version    = var.nvidia_plugin_version
  namespace  = var.nvidia_plugin_namespace
  atomic     = true

  set = [
    {
      name  = "nodeSelector.workload"
      value = "gpu"
    }
  ]
}

resource "helm_release" "vllm" {
  chart     = "../../../vllm-deployment"
  atomic    = true
  name      = var.project
  namespace = kubernetes_namespace_v1.vllm.metadata[0].name
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
    },
    {
      name  = "persistence.size"
      value = var.service_storage_size
    }
  ]
  depends_on = [helm_release.nvidia_device_plugin]

}
