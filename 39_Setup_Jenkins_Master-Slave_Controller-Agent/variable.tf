variable "aws_ami"  {
 type = string
 }
variable "aws_instance_type" {
 type = string
 }
 variable "aws_region" {
    type = string
}
variable "aws_access_key" {
    type = string
}
variable "aws_secret_key" {
    type = string
}
variable "vpc_cidr_block" {
    type = string
}
variable "public_subnet_cidr_block_1" {
    type = string
}
variable "public_subnet_cidr_block_2" {
    type = string
}
variable "private_subnet_cidr_block_1" {  
    type = string
}
variable "private_subnet_cidr_block_2" {
    type = string
}
variable "http_port" {
    type = number
}
variable "ssh_port" {
    type = number
}
variable "aws_key_pair_name" {
    type = string
}