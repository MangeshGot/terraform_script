#=========================VPC CREATION=========================
#Two-Tier Architecture: Jenkins Controller in Public Subnet and Jenkins Agent in Private Subnet
resource "aws_vpc" "jenkins-vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    tags = {Name = "Jenkins-VPC"}
}

#=========================PUBLIC SUBNET 1=========================
resource "aws_subnet" "jenkins-public-subnet-1" {
    vpc_id = aws_vpc.jenkins-vpc.id
    cidr_block = var.public_subnet_cidr_block_1
    availability_zone = "us-east-1a"
    tags = {Name = "Jenkins-Public-Subnet-1"}
}

#=========================PUBLIC SUBNET 2=========================
resource "aws_subnet" "jenkins-public-subnet-2" {
    vpc_id = aws_vpc.jenkins-vpc.id
    cidr_block = var.public_subnet_cidr_block_2
    availability_zone = "us-east-1b"
    tags = {Name = "Jenkins-Public-Subnet-2"}
}
#=========================PRIVATE SUBNET 1=========================
resource "aws_subnet" "jenkins-private-subnet-1" {
    vpc_id = aws_vpc.jenkins-vpc.id
    cidr_block = var.private_subnet_cidr_block_1
    availability_zone = "us-east-1b"
    tags = {Name = "Jenkins-Private-Subnet-1"}
}
#=========================PRIVATE SUBNET 2=========================
resource "aws_subnet" "jenkins-private-subnet-2" {
    vpc_id = aws_vpc.jenkins-vpc.id
    cidr_block = var.private_subnet_cidr_block_2
    availability_zone = "us-east-1d"
    tags = {Name = "Jenkins-Private-Subnet-2"}
}
# ========================INTERNET GATEWAY AND ROUTE TABLES=========================
resource "aws_internet_gateway" "jenkins-igw" {
    vpc_id = aws_vpc.jenkins-vpc.id
    tags = {Name = "Jenkins-IGW"}
}
resource "aws_eip" "jenkins-eip" {
    domain = "vpc"
    tags = {Name = "Jenkins-EIP"}
}
resource "aws_nat_gateway" "jenkins-nat-gw" {
    allocation_id = aws_eip.jenkins-eip.id
    subnet_id = aws_subnet.jenkins-public-subnet-1.id #IMPORTANT!!!! NAT Gateway must be in a public subnet only
    tags = {Name = "Jenkins-NAT-GW"}
}

#=========================ROUTE TABLES=========================
resource "aws_route_table" "jenkins-public-rt" {
    vpc_id = aws_vpc.jenkins-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.jenkins-igw.id
    }
    tags = {Name = "Jenkins-Public-RT"}
}
#========================PRIVATE ROUTE TABLE=========================
resource "aws_route_table" "jenkins-private-rt" {
    vpc_id = aws_vpc.jenkins-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.jenkins-nat-gw.id
    }
    tags = {Name = "Jenkins-Private-RT"}
}

#=========================PUBLIC SUBNET ASSOCIATION=========================
resource "aws_route_table_association" "jenkins-public-rt-assoc-1" {
    subnet_id = aws_subnet.jenkins-public-subnet-1.id
    route_table_id = aws_route_table.jenkins-public-rt.id
}

resource "aws_route_table_association" "jenkins-public-rt-assoc-2" {
    subnet_id = aws_subnet.jenkins-public-subnet-2.id
    route_table_id = aws_route_table.jenkins-public-rt.id
}

#=========================PRIVATE SUBNET ASSOCIATION=========================
resource "aws_route_table_association" "jenkins-private-rt-assoc-1" {
    subnet_id = aws_subnet.jenkins-private-subnet-1.id
    route_table_id = aws_route_table.jenkins-private-rt.id
}

resource "aws_route_table_association" "jenkins-private-rt-assoc-2" {
    subnet_id = aws_subnet.jenkins-private-subnet-2.id
    route_table_id = aws_route_table.jenkins-private-rt.id
}
#========================SECURITY GROUP=========================
resource "aws_security_group" "jenkins-sg" {
    name = "jenkins-sg"
    description = "Allow all inbound HTTP and outbound traffic"
    vpc_id = aws_vpc.jenkins-vpc.id

    ingress {
        from_port   = var.http_port
        to_port     = var.http_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow inbound HTTP traffic on port 8080"
    }
    ingress {
        description = "Allow inbound SSH traffic on port 22"
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow ICMP (Ping) from within the VPC"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
#=========================EC2 INSTANCE CREATION FOR JENKINS CONTROLLER=========================
resource "aws_instance" "jenkins-controller" {
    ami = var.aws_ami
    instance_type = var.aws_instance_type
    key_name = var.aws_key_pair_name
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install fontconfig openjdk-21-jre -y
                sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
                https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
                echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
                https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
                sudo apt update -y
                sudo apt install jenkins -y
                sudo systemctl enable jenkins
                sudo systemctl start jenkins
                EOF
    associate_public_ip_address = true
    subnet_id = aws_subnet.jenkins-public-subnet-1.id
    vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
    tags = {Name = "Jenkins-Controller"}
}
#=========================EC2 INSTANCE CREATION FOR JENKINS AGENT=========================
resource "aws_instance" "jenkins-agent" {
    ami = var.aws_ami
    instance_type = var.aws_instance_type
    key_name = var.aws_key_pair_name
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install fontconfig openjdk-21-jre -y
                EOF
    subnet_id = aws_subnet.jenkins-private-subnet-1.id
    vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
    tags = {Name = "Jenkins-Agent"}
}

output "jenkins_controller_public_ip" {
    value = aws_instance.jenkins-controller.public_ip
}
output "jenkins_agent_private_ip" {
    value = aws_instance.jenkins-agent.private_ip
}