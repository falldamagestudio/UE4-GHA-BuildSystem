module "storage" {
  source = "../../../../submodules/UE4-BuildServices/services/storage"

  location = data.terraform_remote_state.project.outputs.region
  name     = var.name
}
