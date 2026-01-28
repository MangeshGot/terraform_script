variable usersname { }

output "greeting" {
  value = "Hello, ${var.usersname}!"
}

// command : terraform plan -var "usersname=Mangesh"