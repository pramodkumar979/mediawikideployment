# Terraform Block
terraform {
  required_version = ">= 1.6.0" 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.31"
    }
  } 
}  
# Provider Block
provider "aws" {
  region  = var.region
  profile = var.projectName
}