 resource "google_storage_bucket" "static" {
  name          = "python-practice-407605-new12371456"
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
    project = "evident-display-455412-k1"
}

# resource "google_storage_notification" "notification" {
#   bucket         = "bucket-statefile"
#   payload_format = "JSON_API_V1"
#   topic          = google_pubsub_topic.topic.id
#   event_types    = ["OBJECT_FINALIZE"]
#   object_name_prefix = "terraform/state/default.tfstate"
#   custom_attributes = {
#     new-attribute = "new-attribute-value"
#   }
#   depends_on = [google_pubsub_topic_iam_binding.binding]
# }

# // Enable notifications by giving the correct IAM permission to the unique service account.

# data "google_storage_project_service_account" "gcs_account" {
# }


# resource "google_pubsub_topic_iam_binding" "binding" {
#   topic   = google_pubsub_topic.topic.id
#   role    = "roles/pubsub.publisher"
#   members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
# }

// End enabling notifications

# resource "google_storage_bucket" "bucket" {
#   name     = "default_bucket"
#   location = "US"
# }

# resource "google_pubsub_topic" "topic" {
#   name = "storage_topic"
# }


# # Define the Pub/Sub subscription
# resource "google_pubsub_subscription" "subscription" {
#   name  = "storage_sub"  # Replace with your desired subscription name
#   topic = "projects/data-air-433813-q7/topics/storage_topic"  # Replace with your Pub/Sub topic name

#   # Optional settings
#   ack_deadline_seconds = 60  # The time (in seconds) Pub/Sub waits for an ack before retrying
#   retain_acked_messages = true
#   message_retention_duration = "600s"
# }


# resource "google_cloudfunctions_function" "function" {
#   name        = "function-test"
#   description = "My function"
#   runtime     = "python312"
#   project     = "data-air-433813-q7"
#   region      = "europe-west3"

#   available_memory_mb   = 128
#   source_archive_bucket = "bucket-statefile"
#   source_archive_object = "terraform/state/source_repo.zip"

#   event_trigger{
#     event_type = "google.storage.object.finalize"
#     resource = "bucket-statefile"
#   }
# }

# # IAM entry for all users to invoke the function
# resource "google_cloudfunctions_function_iam_member" "invoker" {
#   project        = google_cloudfunctions_function.function.project
#   region         = google_cloudfunctions_function.function.region
#   cloud_function = google_cloudfunctions_function.function.name

#   role   = "roles/cloudfunctions.invoker"
#   member = "allUsers"
# }
#################################

resource "google_service_account" "billing_sa" {
  account_id   = "billing-sa"
  display_name = "Billing Service Account"
  description  = "This is a service account created via Terraform"
}

# Create a BigQuery dataset for billing export
resource "google_bigquery_dataset" "billing_export" {
  dataset_id = "billing_data"
  project    = "evident-display-455412-k1"
  location   = "US"

  labels = {
    environment = "billing"
  }
}

# Grant permissions to the Billing Export system service account
resource "google_bigquery_dataset_iam_member" "billing_export_writer" {
  dataset_id = google_bigquery_dataset.billing_export.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:billing-sa@evident-display-455412-k1.iam.gserviceaccount.com"
}


##############################

resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
