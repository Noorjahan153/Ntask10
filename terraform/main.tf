############################################
# Provider VPC
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
# Security Groups (Existing)
############################################

data "aws_security_group" "alb_sg" {
  id = "sg-022f8a9654e44daf4"
}

############################################
# ALB
############################################

resource "aws_lb" "noor_alb" {
  name               = "noor-alb"
  load_balancer_type = "application"

  security_groups = [data.aws_security_group.alb_sg.id]
  subnets         = data.aws_subnets.default.ids
}

############################################
# Target Groups
############################################

resource "aws_lb_target_group" "noor_blue_tg" {
  name     = "noor-blue-tg"
  port     = 1337
  protocol = "HTTP"

  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group" "noor_green_tg" {
  name     = "noor-green-tg"
  port     = 1337
  protocol = "HTTP"

  vpc_id = data.aws_vpc.default.id
}

############################################
# Listener
############################################

resource "aws_lb_listener" "noor_listener" {
  load_balancer_arn = aws_lb.noor_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.noor_blue_tg.arn
  }
}

############################################
# ECS Cluster
############################################

resource "aws_ecs_cluster" "noor_cluster" {
  name = "noor-cluster"
}

############################################
# ECS Service
############################################

resource "aws_ecs_service" "noor_service" {
  name            = "noor-service"
  cluster         = aws_ecs_cluster.noor_cluster.id
  launch_type     = "FARGATE"
  desired_count   = 1

  task_definition = "PLACE_TASK_DEFINITION_ARN"

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups = [data.aws_security_group.alb_sg.id]
  }
}