module "builders" {
  source = "../../../../services/builders"

  github_scope      = var.github_scope
  github_pat        = var.github_pat
  image             = var.image
  machine_type      = var.machine_type
  boot_disk_size    = var.boot_disk_size
  storage_bucket_id = data.terraform_remote_state.storage.outputs.storage_bucket_id
}
