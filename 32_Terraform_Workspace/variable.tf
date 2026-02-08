variable "access_key" {
  description = "AWS Access Key"
  type        = string
}
variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
}
variable "instance_type" {
  type = string
}
variable "image_id" {
  type = string
}
variable "region" {
  description = "AWS Region"
  type        = string

}
variable "tag_N_type" {
  description = "Tag for the AWS instance"
  type        = string
}