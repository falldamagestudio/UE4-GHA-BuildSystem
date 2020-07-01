terraform {
  backend "gcs" {
    prefix = "game-watchdog"
  }
}