
resource "google_storage_bucket" "this" {
  name          = var.name
  location      = var.location
  force_destroy = true

  bucket_policy_only = true
}

resource "google_storage_bucket_iam_binding" "this" {
  bucket = google_storage_bucket.this.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${var.build_agent_email}",
  ]
}