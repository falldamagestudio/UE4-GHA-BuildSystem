resource "google_storage_bucket_iam_binding" "this" {
  bucket = var.storage_bucket_id
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${var.build_agent_email}",
  ]
}