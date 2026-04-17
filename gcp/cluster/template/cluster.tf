resource "google_service_account" "cluster" {
  account_id   = "${var.project}-cluster-account"
  display_name = "Cluster Account"
}

resource "google_container_cluster" "main" {
  name     = "${var.project}-main-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "node_pools" {
  for_each   = var.node_pools
  name       = "${each.key}-node-pool"
  cluster    = google_container_cluster.main.name
  node_count = each.value.count

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
