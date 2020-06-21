provider "google" {

  version = "~> 3.0"

  project = data.terraform_remote_state.project.outputs.project_id
}

data "terraform_remote_state" "project" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "${var.terraform_cloud_workspace_prefix}-project"
    }
  }
}

module "longtail_store" {
  source = "./longtail_store"

  location = data.terraform_remote_state.project.outputs.region
  name     = var.name
}