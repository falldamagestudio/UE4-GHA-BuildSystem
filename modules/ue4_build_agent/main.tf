resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = var.image
      type = "pd-ssd"
      size = var.boot_disk_size
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = var.metadata

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}