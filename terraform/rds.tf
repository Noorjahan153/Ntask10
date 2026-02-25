resource "aws_db_subnet_group" "noor_db_subnet" {
  name = "noor-db-subnet-group"

  subnet_ids = [
    var.subnet_1,
    var.subnet_2
  ]
}

resource "aws_db_instance" "noor_db" {
  identifier           = "noor-db"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "noordb"
  username             = "postgres"
  password             = "StrongPassword123"
  skip_final_snapshot  = true
  publicly_accessible  = true

  vpc_security_group_ids = [aws_security_group.noor_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.noor_db_subnet.name
}