locals {
  google_apis = [
    "iap.googleapis.com",
    "compute.googleapis.com"
  ]
}

resource "google_project_service" "this" {

  for_each = toset(local.google_apis)

  service = each.key

  disable_on_destroy = false
}
