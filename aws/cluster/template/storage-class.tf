locals {
  storage_classes = {
    persistent = "Retain"
    ephemeral  = "Delete"
  }
}

resource "kubernetes_storage_class_v1" "ebs" {
  for_each = local.storage_classes
  metadata {
    name = "cluster-${each.key}-storage"
    labels = {
      storage_type = each.key
    }
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = each.value
  allow_volume_expansion = true

  parameters = {
    type = var.storage_volume_type
  }
}
