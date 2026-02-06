data "aws_ami" "ubuntu" {
  most_recent = true
  #name = ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251212
  # root device type: ebs
  owners = ["${var.owner}"] # Canonical

  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }
  filter {
    name   = "virtualization-type"
    values = ["${var.virtualization-type}"]
  }

  filter {
    name   = "root-device-type"
    values = ["${var.root_device_type}"]
  }

}
resource "aws_instance" "Terraform_Instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key_pair.key_name
  vpc_security_group_ids = ["${aws_security_group.terraform_sg.id}"]
  tags = {
    name = "EC2UsingTerraform"
  }
  user_data = file("${path.module}/script.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
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
}

