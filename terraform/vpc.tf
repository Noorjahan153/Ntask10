# Use Default VPC (Recommended for DevOps Projects)
data "aws_vpc" "default" {
  default = true
}

# Subnet 1
resource "aws_subnet" "noor_subnet_a" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.48.0/20"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Subnet 2
resource "aws_subnet" "noor_subnet_b" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.64.0/20"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}