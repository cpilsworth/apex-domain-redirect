terraform {
  backend "s3" {
    bucket = "tfstateapexdomainredirect"
    key    = "tfstate/"
    region = "us-east-1"
  }
  required_version = ">= 0.12.0"
}