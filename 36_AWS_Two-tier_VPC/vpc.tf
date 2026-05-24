# Creating Two-tier VPC with Public and Private Subnets in AWS using Terraform

# 1. Create a VPC with CIDR block
resource "aws_vpc" "optiplex_vpc" {
  cidr_block = "192.168.0.0/24"
  instance_tenancy   = "default"
    tags = {    Name = "optiplex_vpc"    }
}

# 2. Create an Internet Gateway and attach it to the VPC

resource "aws_internet_gateway" "optiplex_igw" {
    vpc_id = aws_vpc.optiplex_vpc.id
    tags = { Name = "optiplex_igw" }
}
# 3. Create two public subnets and two private subnets in different availability zones
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.optiplex_vpc.id
  cidr_block = "192.168.0.0/26"
  availability_zone = "us-east-1a"
    tags = {
    Name = "public_subnet_1"
    }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.optiplex_vpc.id
  cidr_block = "192.168.0.64/26"
    availability_zone = "us-east-1b"
        tags = {        Name = "public_subnet_2"    }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.optiplex_vpc.id
  cidr_block = "192.168.0.128/26"
  availability_zone = "us-east-1c"
        tags = {        Name = "private_subnet_1"    }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.optiplex_vpc.id
  cidr_block = "192.168.0.192/26"
    availability_zone = "us-east-1d"
        tags = {        Name = "private_subnet_2"    }  
}

# 4. Create a route table and associate it with the public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.optiplex_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.optiplex_igw.id
  }
  tags = {    Name = "public_rt"    }
}

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}
# 5. Create a route table and associate it with the private subnets
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.optiplex_vpc.id
    tags = { Name = "private_rt" }
}

resource "aws_route_table_association" "private_1_assoc" {
    subnet_id      = aws_subnet.private_1.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
    subnet_id      = aws_subnet.private_2.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_eip" "nat_eip" {
    tags = { Name = "nat_eip" }
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_1.id
    tags = { Name = "nat_gw" }
}