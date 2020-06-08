provider "google" {

  version = "~> 3.0"

  project = var.project_id
}

resource "google_service_account" "this" {
  account_id   = "build-agent"
  display_name = "Build Agent"
}
