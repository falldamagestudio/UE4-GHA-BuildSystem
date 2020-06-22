module "storage" {
  source = "../../../../services/storage"

  location = data.terraform_remote_state.project.outputs.region
  name     = var.name
}
