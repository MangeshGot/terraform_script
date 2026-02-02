resource "aws_key_pair" "key-tf" {
  key_name   = "key_fromTerraform"
  public_key = file("${path.module}/id_rsa.pub")
  }

output "keyname" {
  value = "${aws_key_pair.key-tf.key_name}"
}

#resource "aws_instance" "terraform_instance" {
 # ami           = "ami-0b6c6ebed2801a5cb" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
  #instance_type = "t3.micro"
  #tags = {
   # Name = "TerraformExampleInstance"
  #}
#}

// for creating key on local machine
// use below command
// ssh-keygen -t rsa
// Store it in current directory
// Enter file in which to save the key (/home/mangesh/.ssh/id_rsa): ./id_rsa
// this key can be used in aws key pair