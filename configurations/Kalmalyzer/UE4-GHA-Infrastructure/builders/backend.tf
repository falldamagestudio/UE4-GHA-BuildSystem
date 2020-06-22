terraform {
  backend "gcs" {
    prefix = "builders"
  }
}
