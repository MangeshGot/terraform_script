resource "github_repository" "terraform-first-repo" {
  name = "repo-created-via-terraform"
  description = "This repository was created using Terraform"
  visibility = "public"
  auto_init = true
}

// To refresh the state of the resources managed by Terraform,
// $ terraform refresh
// This command will update the state file with the current status
// of the GitHub repository created above. if anyone has made changes in GitHub

// you can update tfstate accordingly. but in resource block we have not made any changes.
// So after running the refresh command there will be no changes in the resource block.



