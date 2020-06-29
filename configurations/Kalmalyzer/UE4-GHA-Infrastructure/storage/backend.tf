terraform {
  backend "gcs" {
    prefix = "storage"
  }
}