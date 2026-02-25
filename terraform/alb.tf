resource "aws_lb" "noor_alb" {
  name = "noor-strapi-alb"

  internal = false
  load_balancer_type = "application"

  security_groups = []
  subnets = []
}