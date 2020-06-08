provider "google" {

  version = "~> 3.0"

  project = var.project_id
}

module "longtail_store" {
  source            = "../../../../modules/longtail_store"
  name              = var.name
  location          = var.location
  build_agent_email = "build-agent@ue4-gha-game.iam.gserviceaccount.com"
}
