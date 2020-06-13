provider "google" {

  version = "~> 3.0"

  project = data.terraform_remote_state.project.outputs.project_id
}

data "terraform_remote_state" "project" {
  backend = "local"

  config = {
    path = "../project/terraform.tfstate"
  }
}

module "longtail_store" {
  source = "./longtail_store"

  location = data.terraform_remote_state.project.outputs.region
  name     = var.name
}