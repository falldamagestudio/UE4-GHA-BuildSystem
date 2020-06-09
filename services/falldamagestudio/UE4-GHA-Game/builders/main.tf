provider "google" {

  version = "~> 3.0"

  project = data.terraform_remote_state.project.outputs.project_id
  zone    = data.terraform_remote_state.project.outputs.zone
}

data "terraform_remote_state" "project" {
  backend = "local"

  config = {
    path = "../project/terraform.tfstate"
  }
}

data "terraform_remote_state" "storage" {
  backend = "local"

  config = {
    path = "../storage/terraform.tfstate"
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

  github_scope = var.github_scope
  github_pat   = var.github_pat
}
