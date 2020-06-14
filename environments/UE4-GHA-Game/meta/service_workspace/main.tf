resource "tfe_workspace" "this" {
    name = var.workspace
    organization = var.terraform_organization
    file_triggers_enabled = false
    working_directory = var.working_directory
    vcs_repo {
        identifier = var.vcs_repo_identifier
        oauth_token_id = var.github_token_id
    }
}
