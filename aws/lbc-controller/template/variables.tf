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
  default     = "lbc-controller"
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

variable "lbc_namespace" {
  default     = "kube-system"
  description = "Namespace in which to install Load Balancer Controller"
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
