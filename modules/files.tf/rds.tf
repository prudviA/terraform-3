resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private-subnet.id, aws_subnet.private-subnet-2.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "rds-instance" {
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
    Name = "rds-instance"
  }
}

output "rds-endpoint" {
    value = aws_db_instance.rds-instance.endpoint
}