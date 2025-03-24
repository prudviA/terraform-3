resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet-2.id]

  tags = {
    Name = "rds_subnet_group"
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "12345"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  tags = {
    Name = "rds_instance"
  }
}

output "rds_endpoint" {
    value = aws_db_instance.rds_instance.endpoint
}