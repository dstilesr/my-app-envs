resource "kubernetes_storage_class_v1" "ebs" {
  metadata {
    name = "ebs-${var.storage_volume_type}"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true

  parameters = {
    type = var.storage_volume_type
  }
}