resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.noor_vpc.id

  ingress {
    from_port = 1337
    to_port = 1337
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}