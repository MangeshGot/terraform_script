variable "token" {
}

variable "username" {
  default = "MangeshGot"
}
variable "repository" {
  default = "Terraform-Console-Command"
}
variable "issue_title" {
  default = "This is created using Terraform Console Command"
}
variable "issue_body" {
  default = "This issue is created using Terraform Console Command by Mangesh Got"
}
variable "assignees" {
  default = ["MangeshGot"]
}

// $ terraform console
// this command helps to evaluate expressions, check variable values, and 
/// test configurations interactively.