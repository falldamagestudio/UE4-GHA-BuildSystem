module "google_apis" {
  source = "./google_apis"
}

resource "google_compute_firewall" "allow_winrm" {
  name    = "allow-winrm"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5986"]
  }
}
