resource "google_project_service" "services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "container.googleapis.com",
    "serviceusage.googleapis.com"
  ])

  project = var.project_id
  service = each.key

  disable_on_destroy         = false
  disable_dependent_services = false
}