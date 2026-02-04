
output "securityGroupDetails" {
  value = aws_security_group.terraform_sg.id
}

output "ec2InstanceID" {
  value = aws_instance.EC2UsingTerraform.id
}


resource "aws_instance" "EC2UsingTerraform" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key_pair.key_name
  vpc_security_group_ids = ["${aws_security_group.terraform_sg.id}"]
  tags = {
    name = "EC2UsingTerraform"
  }
}