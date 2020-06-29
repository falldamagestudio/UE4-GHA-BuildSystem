resource "google_storage_bucket" "this" {
  name          = var.name
  location      = var.location
  force_destroy = true

  bucket_policy_only = true
}