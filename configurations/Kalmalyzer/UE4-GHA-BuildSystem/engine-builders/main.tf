module "builders" {
  source = "../../../../submodules/UE4-BuildServices/services/builders"

  resource_name_prefix = "engine"

  github_scope      = var.github_scope
  github_pat        = var.github_pat
  image             = var.image
  machine_type      = var.machine_type
  boot_disk_size    = var.boot_disk_size
  instance_name     = var.instance_name
  runner_name       = var.runner_name
  on_demand         = true
  storage_bucket_id = data.terraform_remote_state.engine_storage.outputs.storage_bucket_id
}
