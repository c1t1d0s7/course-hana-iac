# https://registry.terraform.io/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 4.60"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}