terraform {
  backend "gcs" {
    bucket = "bucket-statefile"
    prefix = "terraform/state"
  }
}
