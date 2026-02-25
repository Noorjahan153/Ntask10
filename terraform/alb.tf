resource "aws_lb" "noor_alb" {
  name               = "noor-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.noor_subnet.id]
  security_groups    = [aws_security_group.noor_alb_sg.id]
}

# ✅ Blue Target Group
resource "aws_lb_target_group" "noor_blue_tg" {
  name     = "noor-blue-tg"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = aws_vpc.noor_vpc.id
}

# ✅ Green Target Group
resource "aws_lb_target_group" "noor_green_tg" {
  name     = "noor-green-tg"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = aws_vpc.noor_vpc.id
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