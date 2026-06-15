#=========================EKS VPC Creation=========================
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.eks_vpc_cidr_block
    tags = {
        Name = "eks-vpc"
    }
}
#=========================EKS Public Subnet-1 Creation=========================
resource "aws_subnet" "eks_public_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.eks_public_subnet_cidr_block_1
    availability_zone = "us-east-1a"
    tags = {
        Name = "eks-public-subnet-1"
    }
}
#=========================EKS Public Subnet-2 Creation=========================
resource "aws_subnet" "eks_public_subnet_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.eks_public_subnet_cidr_block_2
    availability_zone = "us-east-1b"
    tags = {
        Name = "eks-public-subnet-2"
    }
}
#=========================EKS Private Subnet-1 Creation=========================
resource "aws_subnet" "eks_private_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.eks_private_subnet_cidr_block_1
    availability_zone = "us-east-1a"
    tags = {
        Name = "eks-private-subnet-1"
    }
}
#=========================EKS Private Subnet-2 Creation=========================
resource "aws_subnet" "eks_private_subnet_2" {
    vpc_id            = aws_vpc.eks_vpc.id
    cidr_block        = var.eks_private_subnet_cidr_block_2
    availability_zone = "us-east-1b"
    tags = {
        Name = "eks-private-subnet-2"
    }
}
#=========================EKS Internet Gateway Creation=========================
resource "aws_internet_gateway" "eks_igw" {
    vpc_id = aws_vpc.eks_vpc.id
    tags = {
        Name = "eks-igw"
    }
}
#=========================NAT Gateway Creation=========================
resource "aws_eip" "eks_nat_eip" {
    domain = "vpc"
    tags = {
        Name = "eks-nat-eip"
    }
}
resource "aws_nat_gateway" "eks_nat_gw" {
    allocation_id = aws_eip.eks_nat_eip.id
    subnet_id     = aws_subnet.eks_public_subnet_1.id #IMPORTANT!!!! NAT Gateway must be in a public subnet only
    tags = {
        Name = "eks-nat-gw"
    }
}
#=========================EKS Public Route Table Creation=========================
resource "aws_route_table" "eks_public_rt" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks_igw.id
    }
    tags = {
        Name = "eks-public-rt"
    }
}
#=========================Public Route Table Association with Public Subnets=========================
resource "aws_route_table_association" "eks_public_subnet_1_assoc" {
    subnet_id      = aws_subnet.eks_public_subnet_1.id
    route_table_id = aws_route_table.eks_public_rt.id
}
resource "aws_route_table_association" "eks_public_subnet_2_assoc" {
    subnet_id      = aws_subnet.eks_public_subnet_2.id
    route_table_id = aws_route_table.eks_public_rt.id
}
#=========================EKS Private Route Table Creation=========================
resource "aws_route_table" "eks_private_rt" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.eks_nat_gw.id
    }
    tags = {
        Name = "eks-private-rt"
    }
}
#=========================Private Route Table Association with Private Subnets=========================
resource "aws_route_table_association" "eks_private_subnet_1_assoc" {
    subnet_id      = aws_subnet.eks_private_subnet_1.id
    route_table_id = aws_route_table.eks_private_rt.id
}
resource "aws_route_table_association" "eks_private_subnet_2_assoc" {
    subnet_id      = aws_subnet.eks_private_subnet_2.id
    route_table_id = aws_route_table.eks_private_rt.id
}