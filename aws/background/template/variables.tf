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


variable "lambda_memory" {
  type        = number
  description = "Memory (MB) to assign to lambda functions here"
  default     = 128
}
