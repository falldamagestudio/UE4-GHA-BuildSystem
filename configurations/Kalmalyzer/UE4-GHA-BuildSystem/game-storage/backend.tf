terraform {
  backend "gcs" {
    prefix = "game-storage"
  }
}