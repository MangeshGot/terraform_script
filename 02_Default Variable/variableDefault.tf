variable username { 
    default = "Admin"
}

output "greetings" {
  value = "Hello, ${var.username}!"
}

// terraform plan -var "username=Mangesh"