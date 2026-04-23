variable "project" {
  type        = string
  description = "Name of Google Cloud Project to use"
}

variable "region" {
  type        = string
  description = "Region in which to deploy GCP resources"
  default     = "us-central1"
}

variable "cluster_deletion_protection" {
  type        = bool
  default     = false
  description = "Whether to add deletion protection to the cluster"
}

variable "cluster_location_suffix" {
  type        = string
  default     = "a"
  description = "Location for the cluster. Will be appended to the region. Leave empty for regional cluster."
}

variable "storage_volume_type" {
  description = "Type of Persistent Disk to use for cluster StorageClasses (e.g. pd-balanced, pd-standard, pd-ssd)"
  type        = string
  default     = "pd-balanced"
}

variable "node_pools" {
  description = "Node pools to add to the cluster"
  type = map(object({
    spot          = bool
    machine_type  = string
    oauth_scopes  = list(string)
    private_nodes = optional(bool, true)
    labels        = optional(map(string), {})

    autoscaling = object({
      total_min_node_count = optional(number)
      total_max_node_count = optional(number)
    })
  }))
  default = {}
}
