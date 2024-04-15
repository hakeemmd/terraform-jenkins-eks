terraform {
  backend "s3" {
    bucket = "hakeembucket"
    key = "eks/terraform.tfstate"
    region = "us-east-1"
    
  }
}