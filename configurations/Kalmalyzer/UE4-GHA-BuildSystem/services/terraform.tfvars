terraform_state_bucket = "kalmalyzer-ue4-gha-buildsystem-state"

# engine_storage

engine_storage_bucket_name = "kalmalyzer-ue4-gha-buildsystem-engine-longtail"

# engine_builders

engine_builder_boot_disk_type = "pd-ssd"
engine_builder_boot_disk_size = "300"
engine_builder_github_scope   = "Kalmalyzer/UE4-GHA-Engine"
engine_builder_machine_type   = "n1-standard-32"
engine_builder_instance_name  = "engine-build-agent"
engine_builder_runner_name    = "engine_build_agent"

# engine_watchdog

engine_watchdog_source_bucket_name = "kalmalyzer-ue4-gha-buildsystem-engine-watchdog-source"
engine_watchdog_function_name      = "kalmalyzer-ue4-gha-buildsystem-engine-watchdog"

engine_watchdog_github_organization = "Kalmalyzer"
engine_watchdog_github_repository   = "UE4-GHA-Engine"

engine_watchdog_scheduling_interval = 10

# game_storage

game_storage_bucket_name = "kalmalyzer-ue4-gha-buildsystem-game-longtail"

# game_builders

game_builder_boot_disk_type = "pd-ssd"
game_builder_boot_disk_size = "100"
game_builder_github_scope   = "Kalmalyzer/UE4-GHA-Game"
game_builder_machine_type   = "n1-standard-32"
game_builder_instance_name  = "game-build-agent"
game_builder_runner_name    = "game_build_agent"

# game_watchdog

game_watchdog_source_bucket_name = "kalmalyzer-ue4-gha-buildsystem-game-watchdog-source"
game_watchdog_function_name      = "kalmalyzer-ue4-gha-buildsystem-game-watchdog"

game_watchdog_github_organization = "Kalmalyzer"
game_watchdog_github_repository   = "UE4-GHA-Game"

game_watchdog_scheduling_interval = 10
