provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key

}
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

data "aws_ami" "ubuntu" {
  most_recent = true
  #name = ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251212
  # root device type: ebs
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
}
output "ami_id" {
  value = data.aws_ami.ubuntu.id
}