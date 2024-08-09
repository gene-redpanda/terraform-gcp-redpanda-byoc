resource "google_service_account" "redpanda_agent" {
  account_id   = "redpanda-agent"
  display_name = "Redpanda Agent Service Account"
  project      = var.project_id
}

resource "google_project_iam_custom_role" "redpanda_agent_role" {
  role_id     = "redpanda_agent_role"
  title       = "Redpanda Agent Role"
  description = "A role comprising general permissions allowing the agent to manage Redpanda cluster resources."
  permissions = [
    "compute.firewalls.get",
    "compute.globalOperations.get",
    "compute.instanceGroupManagers.get",
    "compute.instanceGroupManagers.delete",
    "compute.instanceGroups.delete",
    "compute.instances.list",
    "compute.instanceTemplates.delete",
    "compute.networks.get",
    "compute.networks.getRegionEffectiveFirewalls",
    "compute.networks.getEffectiveFirewalls",
    "compute.projects.get",
    "compute.subnetworks.get",
    "compute.zoneOperations.get",
    "compute.zoneOperations.list",
    "compute.zones.get",
    "compute.zones.list",
    "dns.changes.create",
    "dns.changes.get",
    "dns.changes.list",
    "dns.managedZones.create",
    "dns.managedZones.delete",
    "dns.managedZones.get",
    "dns.managedZones.list",
    "dns.managedZones.update",
    "dns.projects.get",
    "dns.resourceRecordSets.create",
    "dns.resourceRecordSets.delete",
    "dns.resourceRecordSets.get",
    "dns.resourceRecordSets.list",
    "dns.resourceRecordSets.update",
    "iam.roles.get",
    "iam.roles.list",
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.getIamPolicy",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "serviceusage.services.list",
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
  ]
  project = var.project_id
}

resource "google_project_iam_member" "redpanda_agent_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.redpanda_agent_role.id
  member  = "serviceAccount:${google_service_account.redpanda_agent.email}"
}