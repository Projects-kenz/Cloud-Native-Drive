terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.46.0"
    }
  } 

 backend "s3" {
    bucket = "tf-statefile-bkt-hby-projects"
    region = "us-east-2"
    use_lockfile = true
    key = "cld-tf-sec-scale"
  }
}

provider "aws" {
    region = var.aws_region
}