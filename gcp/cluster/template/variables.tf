variable "project" {
  type        = string
  description = "Name of Google Cloud Project to use"
}

variable "region" {
  type        = string
  description = "Region in which to deploy GCP resources"
  default     = "us-central1"
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
