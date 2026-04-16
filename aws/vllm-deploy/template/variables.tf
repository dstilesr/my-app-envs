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

