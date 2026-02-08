resource "aws_instance" "Terraform_Workspace" {
  ami           = var.image_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_N_type
  }
}