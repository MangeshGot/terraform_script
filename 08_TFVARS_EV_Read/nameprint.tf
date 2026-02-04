variable "userFirstName" {
    type = string

}

output "printname" {
    value = "my name is ${var.userFirstName} "
}

// This file defines a variable "userFirstName" of type string and an output "printname" that 
//uses this variable to print a message.
// To use this configuration, you would typically provide a value for "userFirstName"
// through a .tfvars file or command line input when running Terraform commands.

// use the below command to set the environment variable where "TF_VAR_" are use as prefix
// export TF_VAR_userFirstName=mangesh8. TFVARS Config Read
