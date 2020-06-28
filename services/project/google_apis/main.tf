locals {
  google_apis = [
    "iam.googleapis.com",
  "cloudfunctions.googleapis.com",
  "cloudscheduler.googleapis.com",
  "compute.googleapis.com",
	"run.googleapis.com"
  ]
}

resource "google_project_service" "this" {

  for_each = toset(local.google_apis)

  service = each.key

  disable_on_destroy = false
}
