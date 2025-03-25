output "web_instance_public_ip" {
    value = aws_instance.web_instance.public_ip
}

output "app_instance_private_ip" {
    value = aws_instance.app_instance.private_ip
}

output "rds_endpoint" {
 value = aws_db_instance.rds_instance.endpoint
}