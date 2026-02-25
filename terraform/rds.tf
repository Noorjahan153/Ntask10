resource "aws_db_instance" "noor_db" {
  allocated_storage = 20
  engine = "postgres"
  engine_version = "14"

  instance_class = "db.t3.micro"

  username = "admin"
  password = "StrongPassword123"

  skip_final_snapshot = true
}