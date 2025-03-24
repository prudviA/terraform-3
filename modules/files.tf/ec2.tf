resource "aws_instance" "terraform-3" {
  ami           = "ami-05c179eced2eb9b5b"
  instance_type = "t2.micro"
  subnet_id   = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
    tags = {
    Name = "terraform-3"
  }
}
output "ec2_public_ip" {
    value = aws_instance.terraform-3
}

resource "aws_autoscaling_group" "app-asg" {
  availability_zones = ["ap-south-1a"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  vpc_zone_identifier = var.private-subnet.id

}

output "app-asg" {
    value = aws_autoscaling_group.app-asg.name 
}
