variable "access_key" {
    description = "AWS Access Key"
    type        = string  
}
variable "secret_key" {
    description = "AWS Secret Key"
    type        = string 
}
variable "instance_type" {
    description = "Type of AWS EC2 instance"
    type        = string   
}
variable "image_id" {
    description = "AMI ID for the AWS EC2 instance"
    type        = string   
}
variable "key_name" {
    description = "Key name for the AWS EC2 instance"
    type        = string
}