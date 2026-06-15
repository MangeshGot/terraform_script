variable "aws_region" {
  type = string
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "eks_vpc_cidr_block" {
  type = string
}
variable "eks_public_subnet_cidr_block_1" {
  type = string
}
variable "eks_public_subnet_cidr_block_2" {
  type = string
}
variable "eks_private_subnet_cidr_block_1" {
  type = string
}
variable "eks_private_subnet_cidr_block_2" {
  type = string
}