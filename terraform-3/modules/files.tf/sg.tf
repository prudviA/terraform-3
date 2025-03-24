resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.3-tier.id



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
    Name = "app-sg"
  }
}
# Security Group for RDS Database (Database Layer)
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow inbound traffic from application to RDS"
  vpc_id      =  aws_vpc.3-tier.id

  # Inbound Rule - Allow MySQL traffic from EC2 subnet to RDS
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-sg] # Allow EC2 access to RDS
  }

  # Outbound Rule - Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}


output "app-sg.id" {
  value = aws_security_group.app-sg.id
}

output "db-sg.id" {
  value = aws_security_group.db-sg.id
}
