module "watchdog" {
  source = "./watchdog"

  source_path = var.source_path

  source_bucket_name     = var.source_bucket_name
  source_bucket_location = var.source_bucket_location

  function_name   = var.function_name
  function_region = var.function_region

  build_agent_project = var.build_agent_project
  build_agent_zone    = var.build_agent_zone

  github_pat          = var.github_pat
  github_organization = var.github_organization
  github_repository   = var.github_repository

  scheduling_interval           = var.scheduling_interval
}
