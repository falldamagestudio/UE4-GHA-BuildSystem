module "build_agent" {
  source         = "../ue4_gha_build_agent"
  name           = "build-agent"
  image          = var.image
  machine_type   = var.machine_type
  boot_disk_size = var.boot_disk_size

  github_scope = var.github_scope
  github_pat   = var.github_pat
  runner_name  = "build_agent"
}
