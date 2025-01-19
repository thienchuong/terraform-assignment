terraform {
  cloud {
    organization = "toni-assignment"
    workspaces {
      name = "toni-assignment-dev"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
