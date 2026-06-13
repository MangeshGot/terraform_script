#=======================Creating a Two-tier VPC in AWS using Terraform====================#
#=========================VPC=========================
resource "aws_vpc" "optiplex_vpc" {
  cidr_block       = var.vpc_cidr #variable reference
  instance_tenancy = "default"
  tags             = { Name = "optiplex_vpc" }
}
#=========================INTERNET GATEWAY==========================
resource "aws_internet_gateway" "optiplex_igw" {
  vpc_id = aws_vpc.optiplex_vpc.id
  tags   = { Name = "optiplex_igw" }
}
#===========================EIP for NAT Gateway=========================
resource "aws_eip" "nat_eip" {
  tags = { Name = "nat_eip" }
}
#==========================NAT GATEWAY=========================
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id
  tags          = { Name = "nat_gw" }
}
#=========================PUBLIC SUBNET1=========================
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.optiplex_vpc.id
  cidr_block        = var.public_subnet_1_cidr #variable reference
  availability_zone = "us-east-1a"
  tags              = { Name = "public_subnet_1" }
}

#=========================PUBLIC SUBNET2=========================
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.optiplex_vpc.id
  cidr_block        = var.public_subnet_2_cidr #variable reference
  availability_zone = "us-east-1b"
  tags              = { Name = "public_subnet_2" }
}
#=========================PRIVATE SUBNET1=========================
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.optiplex_vpc.id
  cidr_block        = var.private_subnet_1_cidr #variable reference
  availability_zone = "us-east-1c"
  tags              = { Name = "private_subnet_1" }
}
#=========================PRIVATE SUBNET2=========================
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.optiplex_vpc.id
  cidr_block        = var.private_subnet_2_cidr #variable reference
  availability_zone = "us-east-1d"
  tags              = { Name = "private_subnet_2" }
}
#=========================PUBLIC ROUTE TABLES=========================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.optiplex_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.optiplex_igw.id
  }
  tags = { Name = "public_rt" }
}
#========================PRIVATE ROUTE TABLES=========================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.optiplex_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = "private_rt" }
}
#=========================PUBLIC ROUTE TABLE ASSOCIATIONS=========================
resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}
#=========================PRIVATE ROUTE TABLE ASSOCIATIONS=========================
resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}