terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
  backend "s3" {}
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig.yaml"
}

provider "google" {
  region  = var.region
  project = var.project

  default_labels = {
    project    = var.project
    managed_by = "terraform"
    region     = var.region
    component  = "cluster-deployment"
  }
}