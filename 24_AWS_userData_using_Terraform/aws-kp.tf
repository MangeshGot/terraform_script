resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform_ec2_key_pair"
  public_key = file("${path.module}/id_rsa.pub")

}