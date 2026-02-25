# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Existing ALB Security Group
data "aws_security_group" "noor_alb_sg" {
  name = "noor-alb-sg"
}

# Existing ECS Security Group
data "aws_security_group" "noor_ecs_sg" {
  name = "noor-ecs-sg"
}