
# Create a zip archive with the cloud function's source code
data "archive_file" "cloud_function_source_zip" {
  type        = "zip"
  source_dir  = var.source_path
  excludes    = [".git"]
  output_path = "${path.module}/watchdog_cloud_function_source.zip"
}

# Create a storage bucket for the cloud function's source code
resource "google_storage_bucket" "cloud_function_source_bucket" {
  name     = var.source_bucket_name
  location = var.source_bucket_location
}

# Upload the cloud function's source code to the storage bucket
resource "google_storage_bucket_object" "cloud_function_bucket_object" {
  name   = format("watchdog_cloud_function_source.%s.zip", data.archive_file.cloud_function_source_zip.output_md5)
  bucket = google_storage_bucket.cloud_function_source_bucket.name
  source = "${path.module}/watchdog_cloud_function_source.zip"
}

# Deploy the cloud function
resource "google_cloudfunctions_function" "function" {
  depends_on = [google_project_iam_member.function_instance_admin_permissions]

  name                  = var.function_name
  description           = "Watchdog"
  runtime               = "go113"
  region                = var.function_region
  service_account_email = google_service_account.function_service_account.email

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.cloud_function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_bucket_object.name
  trigger_http          = true
  entry_point           = "RunWatchdog"
  environment_variables = {
    GOOGLE_CLOUD_PROJECT = var.build_agent_project
    GCE_ZONE             = var.build_agent_zone
    GITHUB_PAT           = var.github_pat
    GITHUB_ORGANIZATION  = var.github_organization
    GITHUB_REPOSITORY    = var.github_repository
  }
}

# Create a service account. The cloud function will run in the context of this service account
resource "google_service_account" "function_service_account" {
  account_id   = "watchdog-service-account"
  display_name = "Watchdog Service Account"
}

# Grant the cloud function's service account permissions to control any Compute Engine instances within the project
resource "google_project_iam_member" "function_instance_admin_permissions" {
  depends_on = [google_service_account.function_service_account]
  role       = "roles/compute.instanceAdmin.v1"
  member     = "serviceAccount:${google_service_account.function_service_account.email}"
}

# Create a service account. This account can be used to invoke the function via HTTP.
resource "google_service_account" "invoke_function_service_account" {
  account_id   = "invoke-watchdog"
  display_name = "Service account used to invoke the watchdog via HTTP"
}

# Grant the cloud function's invocation service account permissions to launch the function via HTTP
resource "google_cloudfunctions_function_iam_member" "function_invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.invoke_function_service_account.email}"
}

# Create an App Engine application for the scheduler.
# The sole purpose of this application is to enable the cloud scheduler to run.
# See https://www.terraform.io/docs/providers/google/r/cloud_scheduler_job.html for details.
#
# Also, note that this application can currently not be deleted by Terraform without deleting the
#   project as a whole. See https://www.terraform.io/docs/providers/google/r/app_engine_application.html
#   for details.
resource "google_app_engine_application" "scheduler_app" {
  project     = google_cloudfunctions_function.function.project
  location_id = var.scheduler_app_engine_location
}

# Create a scheduler job that invokes the Cloud Function every ${var.scheduling_interval} minutes
resource "google_cloud_scheduler_job" "scheduler_job" {
  depends_on = [google_cloudfunctions_function_iam_member.function_invoker, google_app_engine_application.scheduler_app]

  name             = "watchdog-scheduler-job"
  description      = "Regularly scheduled invocation of the Watchdog"
  region           = google_cloudfunctions_function.function.region
  schedule         = "*/${var.scheduling_interval} * * * *"
  time_zone        = "Etc/UTC"
  attempt_deadline = "60s"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.function.https_trigger_url

    oidc_token {
      service_account_email = google_service_account.invoke_function_service_account.email
    }
  }
}
