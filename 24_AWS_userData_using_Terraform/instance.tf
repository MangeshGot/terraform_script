
output "securityGroupDetails" {
  value = aws_security_group.terraform_sg.id
}

output "ec2InstanceID" {
  value = aws_instance.EC2UsingTerraform.id
}

output "ec2PublicIP" {
  value = aws_instance.EC2UsingTerraform.public_ip  
}

resource "aws_instance" "EC2UsingTerraform" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key_pair.key_name
  vpc_security_group_ids = ["${aws_security_group.terraform_sg.id}"]
  tags = {
    name = "EC2UsingTerraform"
  }
  // or you can use the below user_data script to run any script present in the same directory
  user_data = file("${path.module}/script.sh")
}

// you can use the below user_data script to install nginx on the EC2 instance
#   user_data = <<-EOF
  # #!/bin/bash
  # sudo apt-get update -y
  # sudo apt-get install nginx -y
  # echo "<h1> Deployed via Terraform </h1>" > /var/www/html/index.html
# EOF

// Note : this practice not recommended use File Provisioner instead of user_data for complex scripts