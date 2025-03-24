resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.three_tier.id



 # Inbound Rule - Allow HTTP traffic from ALB to EC2 on port 80
ingress {
    description = "Allow HTTPS traffic for IPv4"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to allow ALB CIDR if needed
  }

  # Inbound Rule - Allow SSH access from trusted IPs (Optional)
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP in production
  }

  # Outbound Rule - Allow all outbound traffic
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2_sg"
  }
}
# Security Group for RDS Database (Database Layer)
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow inbound traffic from application to RDS"
  vpc_id      =  aws_vpc.three_tier.id

  # Inbound Rule - Allow MySQL traffic from EC2 subnet to RDS
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = aws_security_group.app_sg # Allow EC2 access to RDS
  }

  # Outbound Rule - Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_sg"
  }
}


output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
