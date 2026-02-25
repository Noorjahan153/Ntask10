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
# Security Group (Existing)
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

  # ⭐ Use only 2 subnets (Different AZs)
  subnets = [
    data.aws_subnets.default.ids[0],
    data.aws_subnets.default.ids[1]
  ]
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
# ECS Task Definition ⭐ IMPORTANT
############################################

resource "aws_ecs_task_definition" "noor_task" {
  family                   = "noor-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = "arn:aws:iam::811738710312:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = "nginx"
      portMappings = [
        {
          containerPort = 1337
        }
      ]
    }
  ])
}

############################################
# ECS Service
############################################

resource "aws_ecs_service" "noor_service" {

  name            = "noor-service"
  cluster         = aws_ecs_cluster.noor_cluster.id

  desired_count   = 1

  launch_type = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  task_definition = aws_ecs_task_definition.noor_task.arn

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups  = [data.aws_security_group.alb_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.noor_blue_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }
}