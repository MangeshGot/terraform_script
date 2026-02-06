variable "ports" {
  type = list(number)
}
variable "instance_type" {
  type = string
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "image_name" {
  type = string
}
variable "owner" {
  type = string
}
variable "virtualization-type" {
  type = string
}
variable "root_device_type" {
  type = string
}