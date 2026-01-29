resource "github_repository" "terraform-output-command" {
  name = "terraform-output-command"
  visibility = "public"
  auto_init = true
}

output "repourl" {
  value = github_repository.terraform-output-command.html_url
}