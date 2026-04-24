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

variable "kubeconfig_path" {
  description = "Path to KubeConfig file for cluster access"
  default     = "../../cluster/template/kubeconfig.yaml"
  type        = string
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
# Storage
#################################################
variable "storage_volume_type" {
  type        = string
  default     = "gp3"
  description = "EBS volume type to use for the model cache StorageClass"
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

#################################################
# GPU Node Group
#################################################
variable "gpu_node_subnets" {
  type        = list(string)
  description = "Subnets in which to launch GPU worker nodes"
}

variable "gpu_node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for the GPU node group"
  default     = ["g7e.2xlarge"]
}

variable "gpu_node_ami_type" {
  type        = string
  description = "EKS AMI type for GPU nodes"
  default     = "AL2023_x86_64_NVIDIA"
}

variable "gpu_node_capacity_type" {
  type        = string
  description = "Capacity type for GPU nodes (SPOT or ON_DEMAND)"
  default     = "SPOT"
}

variable "gpu_node_disk_size" {
  type        = number
  description = "Root disk size (GiB) for GPU nodes"
  default     = 64
}

variable "gpu_node_desired_size" {
  type    = number
  default = 1
}

variable "gpu_node_min_size" {
  type    = number
  default = 1
}

variable "gpu_node_max_size" {
  type    = number
  default = 1
}

variable "gpu_node_labels" {
  type        = map(string)
  description = "Additional labels for the GPU node group (workload=gpu is always merged in)"
  default     = {}
}

variable "gpu_node_taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}
