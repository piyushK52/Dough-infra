output "resource_id" {
  value = aws_db_instance.rds_instance.resource_id
}

output "address" {
  value = aws_db_instance.rds_instance.address
}

output "port" {
  value = aws_db_instance.rds_instance.port
}
