# Terraform Taint

Note : Terraform not recommanded to use terraform taint command

$ terraform taint aws_security_group.terraform_sg

this command will mark the security group resource for recreation on the next apply
after running the above command if you run 'terraform apply' it will destroy and recreate the security group resource
this is useful when you want to force the recreation of a resource without changing its configuration
use this command with caution as it will cause downtime for the resource being recreated
also note that tainting a resource does not affect its dependencies, so any resources that depend on the tainted resource will not be recreated unless they are also tainted or their configuration changes
