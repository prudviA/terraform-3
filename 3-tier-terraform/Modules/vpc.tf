#Creating a vpc

resource "aws_vpc" "three_tier_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "three_tier_vpc"
  }
}

#Public-subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }
}

#private_subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private-subnet"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private-subnet_2"
  }
}
#internet_gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "igw"
  }
}

#public route-table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}
#public route table association

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#Allocate Elastic IP

resource "aws_eip" "nat_eip" {
    vpc = true
}

# creating NAT gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gateway"
  }
}

# private route table

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id
 
 route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

#private_route_table_association

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}
