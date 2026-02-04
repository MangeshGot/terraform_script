variable user_ids {
  type        = list
}
output print {
    value = "First User ID is: ${var.user_ids[0]}"
}

// Input Variables:
// var.user_ids
//   Enter a value: ["Mangesh","saurav","bhairav"]

// Expected Output Values: 

// Changes to Outputs:
//   + print = "First User ID is: Mangesh"

// terraform plan -var 'user_ids=["mangesh","saurav","bhairav"]'

// Changes to Outputs:
//   + print = "First User ID is: mangesh"