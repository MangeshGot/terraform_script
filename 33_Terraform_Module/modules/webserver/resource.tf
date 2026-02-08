resource "aws_key_pair" "Terraform_Module_Key" {
  key_name   = var.key_name
  public_key = var.key
}

resource "aws_instance" "Terraform_Module" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name = aws_key_pair.Terraform_Module_Key.key_name
  tags = {
    Name = "Created by Terraform Module"
  }
}

