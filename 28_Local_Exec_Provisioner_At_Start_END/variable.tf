variable "ports" {
  description = "List of ports to be opened on the EC2 instance"
  type        = list(number)
}
variable "image_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}