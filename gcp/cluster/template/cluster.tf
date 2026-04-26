resource "google_service_account" "cluster" {
  account_id   = "${var.project}-k8s"
  display_name = "Cluster Account"
}

resource "google_container_cluster" "main" {
  name     = "${var.project}-main-cluster"
  location = var.cluster_location_suffix == "" ? var.region : "${var.region}-${var.cluster_location_suffix}"

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = var.cluster_deletion_protection

  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
    http_load_balancing {
      disabled = false
    }
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
}

resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools
  name     = "${each.key}-node-pool"
  cluster  = google_container_cluster.main.name
  location = google_container_cluster.main.location

  node_config {
    machine_type              = each.value.machine_type
    spot                      = each.value.spot
    local_ssd_encryption_mode = "STANDARD_ENCRYPTION"
    service_account           = google_service_account.cluster.email
    labels                    = merge({ node_group_key = each.key }, each.value.labels)
  }

  autoscaling {
    total_max_node_count = each.value.autoscaling.total_max_node_count
    total_min_node_count = each.value.autoscaling.total_min_node_count
  }
}

resource "null_resource" "download_kubecfg" {
  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG='${path.module}/kubeconfig.yaml' gcloud container clusters get-credentials ${google_container_cluster.main.name} \
        ${var.cluster_location_suffix == "" ? "--region" : "--zone"}=${google_container_cluster.main.location} \
        --project=${var.project}
    EOF
  }

  depends_on = [google_container_cluster.main]
}
