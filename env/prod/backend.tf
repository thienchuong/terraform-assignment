terraform {
  cloud {
    organization = "toni-assignment"
    workspaces {
      name = "toni-assignment-prod"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}
