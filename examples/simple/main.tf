# examples/simple/main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }
}

provider "google" {
    project = var.project_id
    region  = var.region
}
variable "project_id" {
    description = "The project ID"
    type        = string
}

variable "region" {
    description = "The region for resources"
    type        = string
  default = "us-central1"
}

# Create the VPC network
resource "google_compute_network" "redpanda_network" {
  name                    = "redpanda-network"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  project                 = var.project_id
}

module "redpanda_gcp" {
  source = "../.."  # Assumes the module is two directories up from this example

  project_id = var.project_id
  region     = var.region

  network_name = google_compute_network.redpanda_network.name

  primary_subnet_name           = "redpanda-subnet"
  primary_ip_cidr_range         = "10.0.0.0/20"

  secondary_ranges = {
    "pod-range"     = "10.1.0.0/16"
    "service-range" = "10.2.0.0/20"
  }

  router_name     = "redpanda-router"
  address_name    = "redpanda-nat-address"
  nat_config_name = "redpanda-nat-config"

  gke_master_cidr_range = "172.16.0.0/28"

  tiered_storage_bucket_name     = "my-redpanda-tiered-storage"
  management_storage_bucket_name = "my-redpanda-management-storage"
}