data "terraform_remote_state" "project" {
  backend = "gcs"

  config = {
    bucket = var.terraform_state_bucket
    prefix = "project"
  }
}

data "terraform_remote_state" "storage" {
  backend = "gcs"

  config = {
    bucket = var.terraform_state_bucket
    prefix = "storage"
  }
}
