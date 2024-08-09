resource "google_service_account" "redpanda_console" {
  account_id   = "redpanda-console"
  display_name = "Redpanda Console Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "redpanda_console_secret_manager_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.redpanda_console_secret_manager_role.id
  member  = "serviceAccount:${google_service_account.redpanda_console.email}"
}


resource "google_service_account_iam_member" "console_workload_identity" {
  service_account_id = google_service_account.redpanda_console.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[redpanda/console-redpanda-console]"
}

resource "google_project_iam_custom_role" "redpanda_console_secret_manager_role" {
  role_id     = "redpanda_console_secret_manager_role"
  title       = "Redpanda Console Secret Manager Writer"
  description = "Redpanda Console Secret Manager Writer"
  permissions = [
    "secretmanager.secrets.get",
    "secretmanager.secrets.create",
    "secretmanager.secrets.delete",
    "secretmanager.secrets.list",
    "secretmanager.secrets.update",
    "secretmanager.versions.add",
    "secretmanager.versions.destroy",
    "secretmanager.versions.disable",
    "secretmanager.versions.enable",
    "secretmanager.versions.list",
    "iam.serviceAccounts.getAccessToken"
  ]
  project = var.project_id
}