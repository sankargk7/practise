# resource "google_storage_bucket" "static" {
#  name          = "python-practice-407605-new123456"
#  location      = "US"
#  storage_class = "STANDARD"
#  uniform_bucket_level_access = true
# }

resource "google_compute_instance" "vm" {
  name              = "terraform-instance-1234"
  machine_type      = "n2-standard-2"
  zone              = "us-central1-a"
  lifecycle {
    prevent_destroy = true
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
}

provider "google" {
    project = "data-air-433813-q7"
    credentials = data.github_secret.gcp_secret
}

data "github_secret" "gcp_secret" {
name = GCP_SECRET
}
