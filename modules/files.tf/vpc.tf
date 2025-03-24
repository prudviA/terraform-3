resource "aws_vpc" "3_tier" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "3_tier"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.3_tier.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.3_tier.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "private_subnet-2" {
  vpc_id     = aws_vpc.3_tier.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private_subnet-2"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.3_tier.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.3_tier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

output "vpc_id" {
    value = aws_vpc.3_tier_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_id" {
    value = aws_subnet.private_sunets[*].id
}
