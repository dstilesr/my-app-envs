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
  type = list(string)
}
