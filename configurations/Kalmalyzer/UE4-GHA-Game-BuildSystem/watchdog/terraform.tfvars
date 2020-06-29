terraform_state_bucket = "ue4-gha-infrastructure-kalms-state"

source_path        = "../../../../submodules/UE4-GHA-BuildAgentWatchdog"
source_bucket_name = "ue4-gha-infrastructure-kalms-watchdog-source"
function_name      = "ue4-gha-infrastructure-kalms-watchdog"

github_organization = "Kalmalyzer"
github_repository   = "UE4-GHA-Game"

scheduling_interval           = 10