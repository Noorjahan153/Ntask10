############################################
# Default VPC + Subnets
############################################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

############################################
# ECS Cluster
############################################

resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}

############################################
# ALB
############################################

data "aws_security_group" "alb_sg" {
  name = "noor-alb-sg"
}

resource "aws_lb" "strapi_alb" {
  name               = "strapi-alb"
  load_balancer_type = "application"

  security_groups = [data.aws_security_group.alb_sg.id]
  subnets         = data.aws_subnets.default.ids
}