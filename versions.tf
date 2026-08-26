terraform {
  required_version = ">= 1.5.0"

  backend "local" {
    path = "C:/ProgramData/Jenkins/.jenkins/tf-state/exp3.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
