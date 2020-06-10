provider "google" {

  version = "~> 3.0"

  project = var.project_id
}

module "google_apis" {
  source = "./google_apis"
}
