terraform {
  backend "remote" { }
}

provider "tfe" {
  token    = var.terraform_token
  version  = "~> 0.15.0"
}

module "project_workspace" {
    source = "./service_workspace"

    workspace = "${var.github_organization}-${var.github_repository}-project"
    terraform_organization = var.terraform_organization
    working_directory = var.working_directory
    vcs_repo_identifier = "${var.github_organization}/${var.github_repository}"
    github_token_id = var.github_token_id
}
