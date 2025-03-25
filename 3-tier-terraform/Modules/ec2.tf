resource "aws_instance" "web_instance" {
  ami           = "ami-05c179eced2eb9b5b"
  instance_type = "t2.micro"
  subnet_id   = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "web_instance"
  }
}

resource "aws_instance" "app_instance" {
  ami           = "ami-05c179eced2eb9b5b"
  instance_type = "t2.micro"
  subnet_id   = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "app_instance"
  }
}
# rds instance in private subnet

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id,aws_subnet.private_subnet_2.id]

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
  publicly_accessible = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags ={
    Name = "rds_instance"
  }
}

