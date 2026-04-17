variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region in which to deploy"
}

variable "project" {
  type        = string
  default     = "vllm-deployment"
  description = "Name of project to assign to cluster"
}

#################################################
# Remote states
#################################################
variable "remote_state_bucket" {
  type        = string
  description = "Bucket where remote states (cluster) are stored"
}

variable "remote_state_key" {
  type        = string
  description = "Key where remote states (cluster) are stored"
}

variable "remote_state_region" {
  type        = string
  description = "Region where remote states (cluster) are stored"
  default     = "us-west-2"
}

variable "remote_state_lockfile" {
  type        = bool
  description = "Whether the remote state uses S3 lockfile"
  default     = true
}

variable "remote_hf_token_secret" {
  type        = string
  description = "Name of HF token secret"
}

#################################################
# Service
#################################################
variable "service_llm_path" {
  type        = string
  description = "Path of the HuggingFace LLM to deploy"
}

variable "service_image" {
  type        = string
  description = "Docker image of the service for VLLM"
  default     = "vllm/vllm-openai"
}

variable "service_image_tag" {
  type        = string
  description = "Image tag for the service Docker image"
  default     = "v0.19.0"
}

variable "service_storage_size" {
  type        = string
  description = "Size of the persistent storage for the HF cache volume"
  default     = "50Gi"
}

#################################################
# Nvidia device plugin
#################################################
variable "nvidia_plugin_version" {
  type        = string
  default     = "0.19.0"
  description = "Version of the Nvidia device plugin to use to handle GPUs"
}

variable "nvidia_plugin_chart" {
  type        = string
  default     = "nvidia-device-plugin"
  description = "Chart of the nvidia device plugin"
}

variable "nvidia_plugin_namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace in which to deploy the device plugin"
}
