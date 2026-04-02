terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project    = var.project
      managed_by = "Terraform"
      region     = var.region
    }
  }
}

data "aws_caller_identity" "current" {}
