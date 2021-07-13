
module "engine_storage" {

  source = "../../../../submodules/UE4-GHA-BuildServices/services/storage"

  location = data.terraform_remote_state.project.outputs.region
  name     = var.engine_storage_bucket_name
}

module "engine_builders" {
  source = "../../../../submodules/UE4-GHA-BuildServices/services/builders"

  resource_name_prefix = "engine"

  github_scope       = var.engine_builder_github_scope
  github_pat         = var.github_pat
  image              = var.engine_builder_image
  machine_type       = var.engine_builder_machine_type
  boot_disk_type     = var.engine_builder_boot_disk_type
  boot_disk_size     = var.engine_builder_boot_disk_size
  instance_name      = var.engine_builder_instance_name
  runner_name        = var.engine_builder_runner_name
  on_demand          = true
  storage_bucket_ids = [module.engine_storage.storage_bucket_id]

  # Module dependencies
  module_depends_on  = [module.engine_storage.module_depends_on_output]
}

module "engine_watchdog" {
  source = "../../../../submodules/UE4-GHA-BuildServices/services/watchdog"

  source_path = "../../../../submodules/UE4-GHA-BuildAgentWatchdog"

  source_bucket_name     = var.engine_watchdog_source_bucket_name
  source_bucket_location = data.terraform_remote_state.project.outputs.region

  resource_name_prefix = "engine"

  function_name   = var.engine_watchdog_function_name
  function_region = data.terraform_remote_state.project.outputs.region

  build_agent_project = data.terraform_remote_state.project.outputs.project_id
  build_agent_zone    = data.terraform_remote_state.project.outputs.zone

  github_pat          = var.github_pat
  github_organization = var.engine_watchdog_github_organization
  github_repository   = var.engine_watchdog_github_repository

  scheduling_interval = var.engine_watchdog_scheduling_interval
}

module "game_storage" {

  source = "../../../../submodules/UE4-GHA-BuildServices/services/storage"

  location = data.terraform_remote_state.project.outputs.region
  name     = var.game_storage_bucket_name
}

module "game_builders" {
  source = "../../../../submodules/UE4-GHA-BuildServices/services/builders"

  resource_name_prefix = "game"

  github_scope       = var.game_builder_github_scope
  github_pat         = var.github_pat
  image              = var.game_builder_image
  machine_type       = var.game_builder_machine_type
  boot_disk_type     = var.game_builder_boot_disk_type
  boot_disk_size     = var.game_builder_boot_disk_size
  instance_name      = var.game_builder_instance_name
  runner_name        = var.game_builder_runner_name
  on_demand          = true
  storage_bucket_ids = [module.engine_storage.storage_bucket_id, module.game_storage.storage_bucket_id]

  # Module dependencies
  module_depends_on  = [module.engine_storage.module_depends_on_output, module.game_storage.module_depends_on_output]
}

module "game_watchdog" {
  source = "../../../../submodules/UE4-GHA-BuildServices/services/watchdog"

  source_path = "../../../../submodules/UE4-GHA-BuildAgentWatchdog"

  source_bucket_name     = var.game_watchdog_source_bucket_name
  source_bucket_location = data.terraform_remote_state.project.outputs.region

  resource_name_prefix = "game"

  function_name   = var.game_watchdog_function_name
  function_region = data.terraform_remote_state.project.outputs.region

  build_agent_project = data.terraform_remote_state.project.outputs.project_id
  build_agent_zone    = data.terraform_remote_state.project.outputs.zone

  github_pat          = var.github_pat
  github_organization = var.game_watchdog_github_organization
  github_repository   = var.game_watchdog_github_repository

  scheduling_interval = var.game_watchdog_scheduling_interval
}
