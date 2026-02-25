# ✅ Application Load Balancer
resource "aws_lb" "noor_alb" {
  name               = "noor-alb"
  load_balancer_type = "application"

  # MUST be 2 subnets in different AZs
  subnets = [
    aws_subnet.noor_subnet_1.id,
    aws_subnet.noor_subnet_2.id
  ]

  security_groups = [aws_security_group.noor_alb_sg.id]
}

# ✅ Blue Target Group (IMPORTANT: target_type = ip for ECS Fargate)
resource "aws_lb_target_group" "noor_blue_tg" {
  name        = "noor-blue-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.noor_vpc.id
  target_type = "ip"   # VERY IMPORTANT

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ✅ Green Target Group
resource "aws_lb_target_group" "noor_green_tg" {
  name        = "noor-green-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.noor_vpc.id
  target_type = "ip"   # VERY IMPORTANT

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ✅ Listener (Initially pointing to Blue)
resource "aws_lb_listener" "noor_listener" {
  load_balancer_arn = aws_lb.noor_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.noor_blue_tg.arn
  }
}