resource "google_service_account" "redpanda_cluster" {
  account_id   = "redpanda-cluster"
  display_name = "Redpanda Cluster Service Account"
  project      = var.project_id
}

resource "google_storage_bucket_iam_member" "redpanda_cluster_storage_admin" {
  bucket = google_storage_bucket.tiered_storage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.redpanda_cluster.email}"
}

resource "google_service_account_iam_member" "redpanda_cluster_workload_identity" {
  service_account_id = google_service_account.redpanda_cluster.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[redpanda/rp-redpanda-cluster]"
}
