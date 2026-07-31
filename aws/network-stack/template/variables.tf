variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region in which to deploy"
}

variable "project" {
  type        = string
  default     = "common-infra"
  description = "Name of project"
}

variable "component" {
  description = "Name of component for labelling"
  default     = "network-stack"
  type        = string
}

variable "kubeconfig_file" {
  type        = string
  description = "Path to kube config file"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of EKS cluster in which to deploy"
}

variable "namespace" {
  default     = "kube-system"
  description = "Namespace in which to install the Controllers"
  type        = string
}

variable "lbc_version" {
  type        = string
  default     = "3.4.2"
  description = "Version of Load Balancer Controller to install"
}

variable "lbc_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Name of Helm release for LBC."
}

variable "gateway_crds_version" {
  default     = "1.6.1"
  description = "Version of the gateway CRDs to install"
  type        = string
}

variable "external_dns_version" {
  default     = "1.21.1"
  description = "Version of the External DNS controller chart to install"
  type        = string
}
