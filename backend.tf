terraform {
  backend "s3" {
    bucket = "strapi-tf-state-055013504553-xyz7"
    key    = "terraform/state.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}
