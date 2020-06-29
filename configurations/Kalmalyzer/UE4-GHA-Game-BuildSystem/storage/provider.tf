provider "google" {

  version = "~> 3.0"

  project = data.terraform_remote_state.project.outputs.project_id
}
