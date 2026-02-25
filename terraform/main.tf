provider "aws" {
  region = "us-east-1"
}

############################################
# VPC + Subnets (Your Existing)
############################################

data "aws_vpc" "main" {
  id = "vpc-0f72e3c54b764c43b"
}

data "aws_subnets" "main" {
  filter {
    name   = "subnet-id"
    values = [
      "subnet-0b78cbdbc40e4b1bd",
      "subnet-0b97f669dae349838"
    ]
  }
}

############################################
# Security Groups
############################################

resource "aws_security_group" "alb_sg" {
  name   = "strapi-alb-sg"
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "strapi-ecs-sg"
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port = 1337
    to_port   = 1337
    protocol  = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# ALB
############################################

resource "aws_lb" "alb" {
  name = "strapi-alb"
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]
  subnets = data.aws_subnets.main.ids
}

############################################
# Target Groups
############################################

resource "aws_lb_target_group" "blue" {
  name = "blue-tg"
  port = 1337
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = data.aws_vpc.main.id
}

resource "aws_lb_target_group" "green" {
  name = "green-tg"
  port = 1337
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = data.aws_vpc.main.id
}

############################################
# Listener
############################################

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

############################################
# ECS Cluster
############################################

resource "aws_ecs_cluster" "cluster" {
  name = "strapi-cluster"
}

############################################
# ECS Task Definition
############################################

resource "aws_ecs_task_definition" "task" {
  family = "strapi-task"

  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"

  cpu = "256"
  memory = "512"

  execution_role_arn = "arn:aws:iam::055013504553:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name = "strapi"
      image = "nginx"

      portMappings = [{
        containerPort = 1337
      }]
    }
  ])
}

############################################
# ECS Service
############################################

resource "aws_ecs_service" "service" {

  name    = "strapi-service"
  cluster = aws_ecs_cluster.cluster.id

  launch_type   = "FARGATE"
  desired_count = 1

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  task_definition = aws_ecs_task_definition.task.arn

  network_configuration {
    subnets = data.aws_subnets.main.ids
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name = "strapi"
    container_port = 1337
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}