provider "google" {

  version = "~> 3.0"

  project = data.terraform_remote_state.project.outputs.project_id
  zone    = data.terraform_remote_state.project.outputs.zone
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

data "terraform_remote_state" "storage" {
  backend = "remote"

  config = {
    organization = var.terraform_cloud_organization
    workspaces = {
      name = "${var.terraform_cloud_workspace_prefix}-storage"
    }
  }
}

module "build_agent_account" {
  source = "./build_agent_account"
}

module "build_agent_access_to_storage" {
  source = "./build_agent_access_to_storage"

  storage_bucket_id = data.terraform_remote_state.storage.outputs.storage_bucket_id
  build_agent_email = module.build_agent_account.email
}

module "build_agents" {
  source = "./build_agents"

  image          = var.image
  machine_type   = var.machine_type
  boot_disk_size = var.boot_disk_size

  github_scope = var.github_scope
  github_pat   = var.github_pat
}
