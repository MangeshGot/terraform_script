resource "aws_key_pair" "terraform_ec2" {
  key_name   = "terrafor_ec2_key_pair"
  public_key = file("${path.module}/id_rsa.pub")

}

output "ec2_keypair" {
  value = aws_key_pair.terraform_ec2.key_name

}
resource "aws_instance" "terraform_ec2_with_keypair" {
  ami           = "ami-0b6c6ebed2801a5cb" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
  instance_type = "t3.micro"
  key_name      = aws_key_pair.terraform_ec2.key_name

  tags = {
    Name = "Terraform_EC2_with_Keypair_Instance"
  }

}