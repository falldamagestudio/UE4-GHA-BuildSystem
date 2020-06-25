
data "archive_file" "cloud_function_source_zip" {
  type        = "zip"
  source_dir  = var.source_path
  excludes    = [".git"]
  output_path = "${path.module}/watchdog_cloud_function_source.zip"
}

resource "google_storage_bucket" "cloud_function_source_bucket" {
  name = var.source_bucket_name
  location = var.source_bucket_location
}

resource "google_storage_bucket_object" "cloud_function_bucket_object" {
  name   = "watchdog_cloud_function_source.zip"
  bucket = google_storage_bucket.cloud_function_source_bucket.name
  source = "${path.module}/watchdog_cloud_function_source.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  description = "Watchdog"
  runtime     = "go113"
  region      = var.function_region

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.cloud_function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_bucket_object.name
  trigger_http          = true
  entry_point           = "RunWatchdog"
  environment_variables = {
    # No need to set GCP_PROJECT; it is reserved, and automatically set to the function's own project ID
    GCE_ZONE = var.build_agent_zone
    GITHUB_PAT = var.github_pat
    GITHUB_ORGANIZATION = var.github_organization
    GITHUB_REPOSITORY = var.github_repository
  }
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
