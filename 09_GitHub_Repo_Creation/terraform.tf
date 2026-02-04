provider "github" {
    token = "PAT"
}

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

// Command for check which provider is being used
// $ terraform provider 

// To create the repository, run the following commands in your terminal:

// $ terraform init
// $ terraform validate
// $ terraform plan
// $terraform apply

// Confirm the apply action by typing "yes" when prompted.
// After running these commands, check your GitHub account to see the newly created repository.
// Make sure you have set up your GitHub provider authentication,
// such as using a personal access token, to allow Terraform to interact with your GitHub account.
// Ensure you have the GitHub provider configured with appropriate authentication.
// You can set the token as an environment variable like so:
// export GITHUB_TOKEN="your_personal_access_token"
// Replace "your_personal_access_token" with your actual GitHub personal access token.
// For more details, refer to the GitHub provider documentation: https://registry.terraform.io/providers/integrations/github/latest/docs
// Note: Be cautious when sharing your personal access token, as it grants access to your GitHub account.
// Make sure to keep it secure and avoid hardcoding it directly in your Terraform files.
// For more information on creating a personal access token, visit:
// https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
// Remember to destroy the repository when you no longer need it by running:

// $ terraform destroy 

// Command to destroy a specific resource
//$ terraform destroy --target github_repository.terraform-first-repo