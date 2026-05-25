resource "aws_vpc" "main" {
    cidr_block = "192.168.10.0/24"
    instance_tenancy = "default"
    tags = { Name = "VPC_A" }
}

resource "aws_vpc" "peer1" {
    cidr_block = "192.168.20.0/24"
    instance_tenancy = "default"
    tags = { Name = "VPC_B" }
}

resource "aws_vpc" "peer2" {
    cidr_block = "192.168.30.0/24"
    instance_tenancy = "default"
    tags = { Name = "VPC_C" }
}

resource "aws_vpc" "peer3" {
    cidr_block = "192.168.40.0/24"
    instance_tenancy = "default"
    tags = { Name = "VPC_D" }
}

resource "aws_subnet" "SUBNET_A" {
    vpc_id = aws_vpc.main.id
    cidr_block = "192.168.10.0/24"
    availability_zone = "us-east-1a"
    tags = { Name = "SUBNET_A" }
}

resource "aws_subnet" "SUBNET_B" {
    vpc_id = aws_vpc.peer1.id
    cidr_block = "192.168.20.0/24"
    availability_zone = "us-east-1b"
    tags = { Name = "SUBNET_B" }
}

resource "aws_subnet" "SUBNET_C" {
    vpc_id = aws_vpc.peer2.id
    cidr_block = "192.168.30.0/24"
    availability_zone = "us-east-1c"
    tags = { Name = "SUBNET_C" }
}

resource "aws_subnet" "SUBNET_D" {
    vpc_id = aws_vpc.peer3.id
    cidr_block = "192.168.40.0/24"
    availability_zone = "us-east-1d"
    tags = { Name = "SUBNET_D" }
}

resource "aws_instance" "instance1" {
  ami           = "ami-0236922087fa98b6e" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.SUBNET_A.id
  tags = {
    Name = "Instance_in_VPC_A"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-0236922087fa98b6e" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.SUBNET_B.id
  tags = {
    Name = "Instance_in_VPC_B"
  }
}

resource "aws_instance" "instance3" {
  ami           = "ami-0236922087fa98b6e" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.SUBNET_C.id
  tags = {
    Name = "Instance_in_VPC_C"
  }
}

resource "aws_instance" "instance4" {
  ami           = "ami-0236922087fa98b6e" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.SUBNET_D.id
  tags = {
    Name = "Instance_in_VPC_D"
  }
}

resource "aws_ec2_transit_gateway" "main_tgw" {
 description = "Central TGW for VPC communication"
  tags = { Name = "Main-TGW" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_a_attach" {
  subnet_ids         = [aws_subnet.SUBNET_A.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.main.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_b_attach" {
  subnet_ids         = [aws_subnet.SUBNET_B.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.peer1.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_c_attach" {
  subnet_ids         = [aws_subnet.SUBNET_C.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.peer2.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_d_attach" {
  subnet_ids         = [aws_subnet.SUBNET_D.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.peer3.id
}
