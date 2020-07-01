terraform_state_bucket = "kalmalyzer-ue4-gha-buildsystem-state"

source_path        = "../../../../submodules/UE4-GHA-BuildAgentWatchdog"
source_bucket_name = "kalmalyzer-ue4-gha-buildsystem-game-watchdog-source"
function_name      = "kalmalyzer-ue4-gha-buildsystem-game-watchdog"

github_organization = "Kalmalyzer"
github_repository   = "UE4-GHA-Game"

scheduling_interval           = 10