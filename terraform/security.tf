resource "aws_security_group" "ecs_sg" {
  name   = "ecs-security-group"
  vpc_id = "vpc-0778ad9a2069279fc"

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}