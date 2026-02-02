resource "aws_instance" "terraform_instance" {
  ami           = "ami-0b6c6ebed2801a5cb" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
  instance_type = "t3.micro"
  tags = {
    Name = "TerraformExampleInstance"
  }
}
