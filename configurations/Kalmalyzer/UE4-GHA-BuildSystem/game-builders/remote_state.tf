data "terraform_remote_state" "project" {
  backend = "gcs"

  config = {
    bucket = var.terraform_state_bucket
    prefix = "project"
  }
}

data "terraform_remote_state" "engine_storage" {
  backend = "gcs"

  config = {
    bucket = var.terraform_state_bucket
    prefix = "engine-storage"
  }
}

data "terraform_remote_state" "game_storage" {
  backend = "gcs"

  config = {
    bucket = var.terraform_state_bucket
    prefix = "game-storage"
  }
}
