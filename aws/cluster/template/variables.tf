variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region in which to deploy"
}

variable "project" {
  type        = string
  default     = "common-infra"
  description = "Name of project to assign to cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Version of Kubernetes to run on cluster"
  default     = "1.35"
}

variable "kubernetes_bootstrap_addons" {
  type        = bool
  description = "Automatically add default cluster addons such as CoreDNS and AWS - CNI"
  default     = true
}

variable "cluster_subnets" {
  description = "Subnets in which to deploy the cluster"
  type        = list(string)
}

variable "node_groups" {
  description = "Configurations for the node groups"

  type = map(object({
    scaling_config = object({
      desired_size = number
      min_size     = number
      max_size     = number
    })
    instance_types = list(string)
    capacity_type  = string # ON_DEMAND / SPOT
    ami_type       = string
    subnets        = list(string)
    labels = map(string)
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = {}
}

variable "addons" {
  description = "Addon specifications for the cluster"
  type = map(object({
    addon_name           = string
    policy_arn           = optional(string, "")
    configuration_values = optional(string, null)
  }))
  default = {}
}
