resource "google_compute_subnetwork" "primary_subnet" {
  name          = var.primary_subnet_name
  project       = var.project_id
  network       = var.network_name
  ip_cidr_range = var.primary_ip_cidr_range
  region        = var.region

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ranges
    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }
}

resource "google_compute_router" "router" {
  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = var.network_name
}

resource "google_compute_address" "address" {
  name    = var.address_name
  project = var.project_id
  region  = var.region
}

resource "google_compute_firewall" "gke_webhooks" {
  name        = "gke-redpanda-cluster-webhooks"
  description = "Allow master to hit pods for admission controllers/webhooks"
  network     = var.network_name
  project     = var.project_id
  direction   = "INGRESS"

  source_ranges = [var.gke_master_cidr_range]

  allow {
    protocol = "tcp"
    ports    = ["9443", "8443", "6443"]
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = var.nat_config_name
  project                            = var.project_id
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ips                            = [google_compute_address.address.self_link]

  enable_endpoint_independent_mapping = true
}

resource "google_compute_firewall" "redpanda_ingress" {
  name        = "redpanda-ingress"
  description = "Allow access to Redpanda cluster"
  network     = var.network_name
  project     = var.project_id
  direction   = "INGRESS"

  target_tags = ["redpanda-node"]

  source_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "100.64.0.0/10"]

  allow {
    protocol = "tcp"
    ports    = ["9092-9094", "30081", "30082", "30092"]
  }
}






