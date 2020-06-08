provider "google" {

  version = "~> 3.0"

  project = var.project_id
}

module "user_authentication" {
  source            = "../../../../modules/user_authentication"
  support_email     = var.support_email
  application_title = var.application_title
}
