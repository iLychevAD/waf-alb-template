terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.39.0"
    }
    external = {
      source = "hashicorp/external"
      version = "2.2.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
