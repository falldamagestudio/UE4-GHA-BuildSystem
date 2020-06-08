provider "google" {

  version = "~> 3.0"

  project = var.project_id
}

locals {
  google_apis = [
    "iap.googleapis.com"
  ]
}

resource "google_project_service" "this" {

  for_each = toset(local.google_apis)

  service = each.key

  disable_on_destroy = false
}
