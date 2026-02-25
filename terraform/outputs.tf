output "rds_endpoint" {
  value = aws_db_instance.noor_db.endpoint
}

output "alb_dns" {
  value = aws_lb.noor_alb.dns_name
}