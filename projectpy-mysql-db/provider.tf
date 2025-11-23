terraform {
     required_version = ">= 1.10.0"
   

required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = ">= 5.23" ###############----->>
        }
    
  
        tls = {
        source  = "hashicorp/tls"
        version = "~> 4.1" # pick a compatible version
    }
  }
  
backend "s3" {
        bucket = "projectdfd-state-bucket" 
        region = "us-east-1"
        key    = "projectdfd-state/terraform.tfstate"
        use_lockfile   = true
    }
}





provider "aws" { 
region = var.region 

retry_mode = "standard" 
max_retries = 10 
} 

  