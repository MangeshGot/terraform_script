resource "aws_security_group" "terraform_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"


  dynamic "ingress" {
    for_each = [22, 80, 443, 3306, 27017]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
output securityGroupDetails {
    value = "${aws_security_group.terraform_sg.id}"
}
