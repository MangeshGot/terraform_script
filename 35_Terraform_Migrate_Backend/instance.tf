# terraform {
#   backend "s3" {
#     bucket = "mangeshgot"
#     key    = "terraform.tfstate"
#     region = "us-east-1"    
#   }
# }

variable "access_key" {
  description = "AWS Access Key"
  type        = string  
}
variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "example" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"

  tags = {
    Name = "TerraformBackends"
  }
}