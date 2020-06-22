module "build_agent_account" {
  source = "./build_agent_account"
}

module "build_agent_access_to_storage" {
  source = "./build_agent_access_to_storage"

  storage_bucket_id = var.storage_bucket_id
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
