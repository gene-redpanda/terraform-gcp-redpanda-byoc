resource "google_storage_bucket" "tiered_storage" {
  name          = var.tiered_storage_bucket_name
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "management_storage" {
  name          = var.management_storage_bucket_name
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_project_iam_member" "redpanda_agent_container_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.redpanda_agent.email}"
}

resource "google_storage_bucket_iam_member" "redpanda_agent_storage_admin" {
  bucket = google_storage_bucket.management_storage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.redpanda_agent.email}"
}