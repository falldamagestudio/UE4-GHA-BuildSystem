provider "google" {

  version = "~> 3.0"

  project = var.project_id
  region = var.region
  zone = var.zone
}

module "build_agent" {
  source = "../../../../modules/ue4_gha_build_agent"
  name = "build_agent"
  image = "packer-1591213387"
  machine_type = "n1-standard-4"
  boot_disk_size = 200

  github_scope = var.github_scope
  github_pat = var.github_pat
  runner_name = "build_agent"
}
