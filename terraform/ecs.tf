resource "aws_ecs_cluster" "noor_cluster" {
  name = "noor-cluster"
}
resource "aws_ecs_task_definition" "noor_task" {
  family                   = "noor-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::811738710312:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name  = "noor-container"
      image = "placeholder"
      portMappings = [{
        containerPort = 1337
      }]
    }
  ])
}
resource "aws_ecs_service" "noor_service" {
  name            = "noor-service"
  cluster         = aws_ecs_cluster.noor_cluster.id
  task_definition = aws_ecs_task_definition.noor_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

 network_configuration {
  subnets = [
    "subnet-0cc23dc8400d81bf3",
    "subnet-00efaeabe6a244f6f"
  ]
  security_groups = [aws_security_group.noor_ecs_sg.id]
  assign_public_ip = true
}

  load_balancer {
    target_group_arn = aws_lb_target_group.noor_blue_tg.arn
    container_name   = "noor-container"
    container_port   = 1337
  }
}