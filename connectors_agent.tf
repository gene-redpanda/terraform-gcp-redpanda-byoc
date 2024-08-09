resource "google_service_account" "redpanda_connectors" {
  account_id   = "redpanda-connectors"
  display_name = "Redpanda Connectors Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "redpanda_connectors_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.redpanda_connectors_role.id
  member  = "serviceAccount:${google_service_account.redpanda_connectors.email}"
}


resource "google_service_account_iam_member" "connectors_workload_identity" {
  service_account_id = google_service_account.redpanda_connectors.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[redpanda-connectors/connectors-redpanda-connectors]"
}

resource "google_project_iam_custom_role" "redpanda_connectors_role" {
  role_id     = "redpanda_connectors_role"
  title       = "Redpanda Connectors Custom Role"
  description = "Redpanda Connectors Custom Role"
  permissions = [
    "resourcemanager.projects.get",
    "secretmanager.versions.access"
  ]
  project = var.project_id
}
