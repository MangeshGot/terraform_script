resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform_ec2_key_pair"
  public_key = file("${path.module}/id_rsa.pub")

}

resource "aws_security_group" "terraform_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"


  dynamic "ingress" {
    for_each = [22, 80, 443, 3306, 27017]
    iterator = port
    content {
      description      = "TLS from VPC"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
output "securityGroupDetails" {
  value = aws_security_group.terraform_sg.id
}

output "ec2InstanceID" {
  value = aws_instance.EC2UsingTerraform.id
}


resource "aws_instance" "EC2UsingTerraform" {
  ami                    = "ami-0b6c6ebed2801a5cb" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.terraform_key_pair.key_name
  vpc_security_group_ids = ["${aws_security_group.terraform_sg.id}"]
  tags = {
    name = "EC2UsingTerraform"
  }
}