resource "github_repository" "terraform-output-command" {
  name = "terraform-output-command"
  visibility = "public"
  auto_init = true
}

output "repo_url" {
  value = github_repository.terraform-output-command.html_url
}

// Commands to run the Terraform script
// $ terraform init
// $ terraform validate 
// $ terraform plan
// $ terraform apply -auto-approve

// To get the output value html_url
// now use $ terraform plan command by change output lablel from repourl to repo_url
// It will show the changes in output
// Example output after running terraform plan command
// OUTPUT :
// github_repository.terraform-output-command: Refreshing state... [id=terraform-output-command]

// Changes to Outputs:
  // + repo_url = "https://github.com/MangeshGot/terraform-output-command"
  // - repourl  = "https://github.com/MangeshGot/terraform-output-command" -> null

// Finally run the command to get the output value
// $ terraform output repo_url
// It will return the output value
// OUTPUT :
// https://github.com/MangeshGot/terraform-output-command