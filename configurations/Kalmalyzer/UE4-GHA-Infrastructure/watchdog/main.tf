module "watchdog" {
  source = "../../../../services/watchdog"

  source_path = var.source_path

  source_bucket_name     = var.source_bucket_name
  source_bucket_location = data.terraform_remote_state.project.outputs.region

  function_name   = var.function_name
  function_region = data.terraform_remote_state.project.outputs.region

  build_agent_project = data.terraform_remote_state.project.outputs.project_id
  build_agent_zone    = data.terraform_remote_state.project.outputs.zone

  github_pat          = var.github_pat
  github_organization = var.github_organization
  github_repository   = var.github_repository

  scheduling_interval           = var.scheduling_interval
}
