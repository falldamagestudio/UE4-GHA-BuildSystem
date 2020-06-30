terraform_state_bucket = "kalms-ue4-gha-game-bs-state"

source_path        = "../../../../submodules/UE4-GHA-BuildAgentWatchdog"
source_bucket_name = "kalms-ue4-gha-game-bs-watchdog-source"
function_name      = "kalms-ue4-gha-game-bs-watchdog"

github_organization = "Kalmalyzer"
github_repository   = "UE4-GHA-Game"

scheduling_interval           = 10