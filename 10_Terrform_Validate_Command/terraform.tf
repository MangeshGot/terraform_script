resource "github_repository" "terraform-first-repo" {
  name = "repo-created-via-terraform"
  description = "This repository was created using Terraform"
  visibility = "public"
  auto_init = true
}

resource "github_repository" "terraform-second-repo" {
  name = "repo-created-via-terraform-second"
  description = "This repository was created using Terraform"
  visibility = "public"
  auto_init = true
}

// To validate the configuration files
// $ terraform validate

// in this lab we we make seperate file for variable and tfvars and provider
// we will pass the token value from tfvars file to variable file and from variable file to provider file
// this is best practice to avoid hardcoding sensitive information like token in provider file