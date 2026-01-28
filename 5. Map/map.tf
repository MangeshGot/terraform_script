variable "usersage" {
    type = map
    default = {
        mangesh = 25
        saurav  = 30
        bhairav = 28
    }
}

variable "username" {
    type = string

}

output "userage" {
    value = "my name is ${var.username} and my age is ${var.usersage[var.username]}"
}

// varible assignment command
// terraform plan -var 'username=mangesh'

// with plan command
// terraform plan
// output :
//var.username
  //Enter a value: saurav