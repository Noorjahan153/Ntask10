# Use Default AWS VPC (Recommended for DevOps Projects)
data "aws_vpc" "default" {
  default = true
}

# Get Existing Subnets from Default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}