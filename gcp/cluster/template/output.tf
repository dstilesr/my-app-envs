output "storage_class_names" {
  description = "Names for storage classes (ephemeral and persistent) created on the cluster"
  value       = { for k, v in kubernetes_storage_class_v1.pd : k => v.metadata[0].name }
}

output "cluster_id" {
  description = "ID of the cluster"
  value       = google_container_cluster.main.id
}

output "cluster_name" {
  description = "Name of the GCP cluster"
  value       = google_container_cluster.main.name
}

output "node_service_account_email" {
  description = "Email of service account used for nodes"
  value       = google_service_account.cluster.email
}

output "node_service_account_id" {
  description = "ID of service account used for nodes"
  value       = google_service_account.cluster.id
}
