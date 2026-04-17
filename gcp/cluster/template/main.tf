terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
  backend "s3" {}
}

provider "google" {
  region  = var.region
  project = var.project

  default_labels = {
    project   = var.project
    ManagedBy = "Terraform"
    region    = var.region
    component = "cluster-deployment"
  }
}