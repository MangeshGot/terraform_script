variable "age" {
    type = number
}

variable "username" {
    type = string

}

output "userage" {
    value = "my name is ${var.username} and my age is ${var.age}"
}

// varible using terraform plan command

//mangesh@mangesh-OptiPlex-5050:~/Documents/Project/Terraform/create_vpc/TFVARs Files$ terraform plan
//var.age
  //Enter a value: 31

//var.username
  //Enter a value: Mangesh


//Changes to Outputs:
  //+ userage = "my name is Mangesh and my age is 31"

// Command to run with specific tfvars file
//  terraform plan -var-file=devlopment.tfvars