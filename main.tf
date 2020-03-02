provider "aws" {
  version = "~> 2.8"
  region  = "eu-west-1"
}
resource "aws_globalaccelerator_accelerator" "example" {
  name            = "apex-domain-redirect"
  ip_address_type = "IPV4"
  enabled         = true
}