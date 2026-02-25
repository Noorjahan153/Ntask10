terraform {
  backend "s3" {
    bucket = "strapi-nor-state-001"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
  }
}