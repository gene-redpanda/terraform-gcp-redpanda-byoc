variable "project_id" {
  description = "The ID of the host project"
  type        = string
}

variable "network_name" {
  description = "The name of the shared VPC network"
  type        = string
}

variable "region" {
  description = "The region for resources"
  type        = string
}

variable "primary_subnet_name" {
  description = "The name of the primary subnet"
  type        = string
}

variable "router_name" {
  description = "The name of the compute router"
  type        = string
}

variable "address_name" {
  description = "The name of the compute address"
  type        = string
}

variable "nat_config_name" {
  description = "The name of the NAT configuration"
  type        = string
}

variable "gke_master_cidr_range" {
  description = "The CIDR range for GKE master"
  type        = string
}

variable "tiered_storage_bucket_name" {}
variable "management_storage_bucket_name" {}

variable "primary_ip_cidr_range" {
  description = "The primary IP CIDR range for the subnet"
  type        = string
}

variable "secondary_ranges" {
  description = "A map of secondary range names to CIDR ranges"
  type        = map(string)
  default     = {}
}