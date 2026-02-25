resource "aws_vpc" "noor_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet 1 (AZ-a)
resource "aws_subnet" "noor_subnet_a" {
  vpc_id                  = aws_vpc.noor_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Subnet 2 (AZ-b)
resource "aws_subnet" "noor_subnet_b" {
  vpc_id                  = aws_vpc.noor_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}