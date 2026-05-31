# Creating VPC
resource "aws_vpc" "main" {
	cidr_block = "192.168.0.0/24"
	instance_tenancy = "default"
	tags = { Name = "optiplex-vpc" }
}
# Creating Subnet
resource "aws_subnet" "optiplex_vpc" {
	vpc_id = aws_vpc.main.id
	cidr_block = "192.168.0.0/26"
	availability_zone = "us-east-1a"
	tags = { Name = "subnet-1" }
}
# Creating Internet Gateway
resource "aws_internet_gateway" "optiplex_igw" {
	vpc_id = aws_vpc.main.id
	tags = { Name = "optiplex_igw"}
}
# Creating Route Table and associating it with Subnet
resource "aws_route_table" "public_rt" {
	vpc_id = aws_vpc.main.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.optiplex_igw.id
	}
	tags = { Name = "public_rt" }
}
# Associating Route Table with Subnet
resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id = aws_subnet.optiplex_vpc.id
    route_table_id = aws_route_table.public_rt.id
}
# Creating Security Group to allow all traffic
resource "aws_security_group" "all_traffic" {
    name = "all_traffic"
    description = "Allow all inbound and outbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  
}
# Creating EC2 instance
resource "aws_instance" "optiplex_ec2" {
    ami = "ami-091138d0f0d41ff90"
    instance_type = "t3.micro"

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install pipx -y
                pipx install --include-deps ansible
                EOF
    key_name = "ketan"
    subnet_id = aws_subnet.optiplex_vpc.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.all_traffic.id]
    tags = { Name = "optiplex_ec2" }
}
# Output the public IP of the EC2 instance
output "public_ip" {
    value = aws_instance.optiplex_ec2.public_ip
}