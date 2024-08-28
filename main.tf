 resource "google_storage_bucket" "static" {
  name          = "python-practice-407605-new1237456"
  location      = "US"
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
}
/*
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
*/
provider "google" {
    project = "data-air-433813-q7"
}

resource "google_storage_notification" "notification" {
  bucket         = "bucket-statefile"
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  event_types    = ["OBJECT_FINALIZE"]
  object_name_prefix = "terraform/state/default.tfstate"
  custom_attributes = {
    new-attribute = "new-attribute-value"
  }
  depends_on = [google_pubsub_topic_iam_binding.binding]
}

// Enable notifications by giving the correct IAM permission to the unique service account.


resource "google_pubsub_topic_iam_binding" "binding" {
  topic   = google_pubsub_topic.topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:test-sa@data-air-433813-q7.iam.gserviceaccount.com"]
}

// End enabling notifications

# resource "google_storage_bucket" "bucket" {
#   name     = "default_bucket"
#   location = "US"
# }

resource "google_pubsub_topic" "topic" {
  name = "storage_topic"
}
