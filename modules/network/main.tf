#######################
### Enable services ###
#######################
locals {
  network_apis = [
    "compute.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "dns.googleapis.com"
  ]
}

resource "google_project_service" "api" {
  for_each = toset(local.network_apis)
  service  = each.key
  project  = var.project_id

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

##############
### Locals ###
##############
locals {
  subnets = {
    for vpc, subnets in var.subnets : vpc => [
      for subnet in subnets : subnet.subnet_region != null ? subnet : merge(subnet, { subnet_region = var.region })
    ]
  }
}

###############
### Network ###
###############
module "vpc" {
  for_each = var.vpc
  source   = "terraform-google-modules/network/google"
  version  = "~> 7.3"

  project_id                             = each.value.project_id != null ? each.value.project_id : var.project_id
  network_name                           = each.key
  routing_mode                           = each.value.routing_mode
  description                            = each.value.description
  delete_default_internet_gateway_routes = each.value.delete_default_internet_gateway_routes

  auto_create_subnetworks = each.value.auto_create_subnetworks
  mtu                     = each.value.mtu

  subnets = try(local.subnets[each.key], [])

  secondary_ranges = { for i in try(local.subnets[each.key], []) : i.subnet_name => try(var.secondary_ranges[i.subnet_name], []) }

  routes = concat([
    for route in var.default_routes : merge(route, { name = "${route.name}-${each.key}" })
  ], try(var.routes[each.key], []))

  firewall_rules = try(var.firewall_rules[each.key], [])

  depends_on = [
    google_project_service.api
  ]
}

###########################
### Hub Spoke (peering) ###
###########################
module "hub_spoke" {
  for_each = var.hub_network != null ? toset(var.spoke_networks) : toset([])
  source   = "terraform-google-modules/network/google//modules/network-peering"
  version  = "~> 7.3"

  local_network = module.vpc[var.hub_network].network_self_link
  peer_network  = module.vpc[each.key].network_self_link
  depends_on = [
    google_project_service.api,
    module.vpc
  ]
}

##############################################
### Private Service Access (For Cloud SQL) ###
##############################################
resource "google_compute_global_address" "private_service_access_address" {
  for_each      = var.private_service_access
  name          = "ga-${each.key}-vpc-peering-internal"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", each.value), 0)
  prefix_length = element(split("/", each.value), 1)
  network       = module.vpc[each.key].network_self_link
  depends_on = [
    google_project_service.api,
    module.vpc
  ]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  for_each                = var.private_service_access
  network                 = module.vpc[each.key].network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address[each.key].name]
  depends_on = [
    google_project_service.api,
    module.vpc
  ]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  for_each = var.private_service_access
  peering  = google_service_networking_connection.private_vpc_connection[each.key].peering
  network  = each.key
  project       = var.project_id

  import_custom_routes = true
  export_custom_routes = true
}

###########
### NAT ###
###########
locals {
  nat_static_addresses         = { for k, nat in var.nat : k => [for i in range(try(nat.number_static_addresses, 0)) : "sip-${k}-${i}"] }
  nat_static_addresses_regions = [for k, nat in var.nat : { for i in range(try(nat.number_static_addresses, 0)) : "sip-${k}-${i}" => nat.region != null ? "${nat.region}" : var.region }]
}

resource "google_compute_address" "nat_static_address" {
  for_each = toset(flatten(values(local.nat_static_addresses)))
  project  = var.project_id
  name     = each.value
  region   = merge(local.nat_static_addresses_regions...)[each.value]
  depends_on = [
    google_project_service.api,
    module.vpc
  ]
}

module "nat" {
  for_each   = var.nat
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 4.0"
  name       = each.key
  project_id = var.project_id
  region     = each.value.region != null ? each.value.region : var.region
  network    = each.value.network
  router     = each.value.router

  min_ports_per_vm = try(each.value.min_ports_per_vm, "64")

  router_asn                         = try(each.value.router_asn, "64514")
  log_config_enable                  = try(each.value.log_config_enable, false)
  log_config_filter                  = try(each.value.log_config_filter, "ALL")
  source_subnetwork_ip_ranges_to_nat = try(each.value.source_subnetwork_ip_ranges_to_nat, "ALL_SUBNETWORKS_ALL_IP_RANGES")
  subnetworks                        = try(each.value.subnetworks, [])
  create_router                      = true

  nat_ips = [for ip in local.nat_static_addresses[each.key] : google_compute_address.nat_static_address[ip].id]
  depends_on = [
    google_project_service.api,
    module.vpc
  ]
}

###########
### DNS ###
###########
module "dns" {
  for_each   = var.dns
  source     = "terraform-google-modules/cloud-dns/google"
  version    = "5.0.1"
  project_id = var.project_id
  type       = each.value.type
  name       = each.key
  domain     = each.value.domain

  private_visibility_config_networks = try([for network in each.value.private_visibility_config_networks : module.vpc[network].network_self_link], [])
  target_name_server_addresses       = each.value.target_name_server_addresses
  target_network                     = each.value.target_network
  dnssec_config                      = each.value.dnssec_config
  default_key_specs_key              = each.value.default_key_specs_key
  default_key_specs_zone             = each.value.default_key_specs_zone

  recordsets = try(var.recordsets[each.key], [])
  depends_on = [
    google_project_service.api,
    module.vpc
  ]
}