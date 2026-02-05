
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

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip // aws_instance.EC2UsingTerraform.public_ip -> self.public_ip refers to the current resource which qill avoid dead loop
  }

  // Provisioner are three types: file, remote-exec and local-exec
  provisioner "file" {
    source      = "${path.module}/README.md" // In Terraform Machine
    destination = "/tmp/README.md"           // In EC2 remote Machine
  }

  provisioner "file" {
    source      = "${path.module}/content.md" // In Terraform Machine
    destination = "/tmp/content.md"           // In EC2 remote Machine
  }

  provisioner "local-exec" {
    working_dir = "/home/mangesh/Documents/Project/terraform_script/28_Local_Exec_Provisioner_At_Start_END"
    command     = "echo ${aws_instance.EC2UsingTerraform.public_ip} > instance_details.txt && echo ${aws_instance.EC2UsingTerraform.id} >> instance_details.txt && echo ${aws_security_group.terraform_sg.id} >> instance_details.txt"
  }

  provisioner "local-exec" {
    command = "env > env_details.txt"
    environment = {
      envname = "envvalue"
    }
  }

  provisioner "local-exec" {
    command = "echo At Creation Time"
    when    = create
  }
  provisioner "local-exec" {
    command = "echo At Destruction Time"
    when    = destroy
  }
  // if provisioner fails, the resource will tained state meaning it will destroy the resource and recreate it
}

