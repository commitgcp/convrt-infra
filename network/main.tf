###############
### Network ###
###############
module "network" {
  for_each = var.vpc
  source   = "../modules/network"

  project_id = each.key
  #org_id     = var.org_id
  region = var.region

  ###########
  ### VPC ###
  ###########
  vpc                    = each.value
  private_service_access = try(var.private_service_access[each.key], {})

  ###############
  ### Subnets ###
  ###############
  subnets = try(var.subnets[each.key], {})
  #secondary_ranges = try(var.secondary_ranges[each.key], {})

  #################
  ### Firewalls ###
  #################
  firewall_rules = try(var.firewall[each.key], {})

  ###########
  ### NAT ###
  ###########
  nat = try(var.nat[each.key], {})

  ###########
  ### DNS ###
  ###########
  dns        = try(var.dns[each.key], {})
  recordsets = try(var.recordsets[each.key], {})
}

#############################
### Hierarchical Firewall ###
#############################
# module "hierarchical_firewall" {
#   for_each     = var.hierarchical_firewall
#   source       = "../modules/hierarchical_firewall_policy"
#   name         = each.key
#   associations = length(each.value.associations) > 0 ? each.value.associations : each.value.parent != null ? [each.value.parent] : ["organizations/${var.org_id}"]
#   rules        = each.value.rules
#   parent       = each.value.parent != null ? each.value.parent : "organizations/${var.org_id}"
# }

#######################
### Hub Spoke (VPN) ###
#######################
module "vpn_mgmt_to_dev" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 3.1"
  project_id       = var.vpn_mgmt_dev.mgmt_project_id
  region           = var.region
  network          = "https://www.googleapis.com/compute/v1/projects/${var.vpn_mgmt_dev.mgmt_project_id}/global/networks/${var.vpn_mgmt_dev.mgmt_network}"
  name             = "vpn-mgmt-to-dev"
  peer_gcp_gateway = module.vpn_dev_to_mgmt.self_link
  router_asn       = 64518

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

  }
}

module "vpn_dev_to_mgmt" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 3.1"
  project_id       = var.vpn_mgmt_dev.dev_project_id
  region           = var.region
  network          = "https://www.googleapis.com/compute/v1/projects/${var.vpn_mgmt_dev.dev_project_id}/global/networks/${var.vpn_mgmt_dev.dev_network}"
  name             = "vpn-dev-to-mgmt"
  router_asn       = 64513
  peer_gcp_gateway = module.vpn_mgmt_to_dev.self_link
  router_advertise_config = {
    groups = ["ALL_SUBNETS"]
    ip_ranges = {
      "${var.private_service_access.convrt-dev.vpc-dev}" = "Postgres SQL instance"
    }
    mode = "CUSTOM"
  }

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64518
      }
      bgp_session_range     = "169.254.1.1/30"
      ike_version           = 2
      vpn_gateway_interface = 0
      shared_secret         = module.vpn_mgmt_to_dev.random_secret
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64518
      }
      bgp_session_range     = "169.254.2.1/30"
      ike_version           = 2
      vpn_gateway_interface = 1
      shared_secret         = module.vpn_mgmt_to_dev.random_secret
    }
  }
}

module "vpn_mgmt_to_preprod" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 3.1"
  project_id       = var.vpn_mgmt_preprod.mgmt_project_id
  region           = var.region
  network          = "https://www.googleapis.com/compute/v1/projects/${var.vpn_mgmt_preprod.mgmt_project_id}/global/networks/${var.vpn_mgmt_preprod.mgmt_network}"
  name             = "vpn-mgmt-to-preprod"
  peer_gcp_gateway = module.vpn_preprod_to_mgmt.self_link
  router_asn       = 64521

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.100.1"
        asn     = 64522
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.100.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.101.1"
        asn     = 64522
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.101.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

  }
}

module "vpn_preprod_to_mgmt" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 3.1"
  project_id       = var.vpn_mgmt_preprod.preprod_project_id
  region           = var.region
  network          = "https://www.googleapis.com/compute/v1/projects/${var.vpn_mgmt_preprod.preprod_project_id}/global/networks/${var.vpn_mgmt_preprod.preprod_network}"
  name             = "vpn-preprod-to-mgmt"
  router_asn       = 64522
  peer_gcp_gateway = module.vpn_mgmt_to_preprod.self_link
  router_advertise_config = {
    groups = ["ALL_SUBNETS"]
    ip_ranges = {
      "${var.private_service_access.preprod-423309.vpc-preprod}" = "Postgres SQL instance"
    }
    mode = "CUSTOM"
  }

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.100.2"
        asn     = 64521
      }
      bgp_session_range     = "169.254.100.1/30"
      ike_version           = 2
      vpn_gateway_interface = 0
      shared_secret         = module.vpn_mgmt_to_preprod.random_secret
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.101.2"
        asn     = 64521
      }
      bgp_session_range     = "169.254.101.1/30"
      ike_version           = 2
      vpn_gateway_interface = 1
      shared_secret         = module.vpn_mgmt_to_preprod.random_secret
    }
  }
}

module "vpn_mgmt_to_prod" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 3.1"
  project_id       = var.vpn_mgmt_prod.mgmt_project_id
  region           = var.region
  network          = "https://www.googleapis.com/compute/v1/projects/${var.vpn_mgmt_prod.mgmt_project_id}/global/networks/${var.vpn_mgmt_prod.mgmt_network}"
  name             = "vpn-mgmt-to-prod"
  peer_gcp_gateway = module.vpn_prod_to_mgmt.self_link
  router_asn       = 64519

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.10.1"
        asn     = 64520
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.10.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.20.1"
        asn     = 64520
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.20.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

  }
}

module "vpn_prod_to_mgmt" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 3.1"
  project_id       = var.vpn_mgmt_prod.prod_project_id
  region           = var.region
  network          = "https://www.googleapis.com/compute/v1/projects/${var.vpn_mgmt_prod.prod_project_id}/global/networks/${var.vpn_mgmt_prod.prod_network}"
  name             = "vpn-prod-to-mgmt"
  router_asn       = 64520
  peer_gcp_gateway = module.vpn_mgmt_to_prod.self_link
  router_advertise_config = {
    groups = ["ALL_SUBNETS"]
    ip_ranges = {
    "${var.private_service_access.convrt-prod.vpc-prod}" = "Postgres SQL instance"
    }
    mode = "CUSTOM"
  }

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.10.2"
        asn     = 64519
      }
      bgp_session_range     = "169.254.10.1/30"
      ike_version           = 2
      vpn_gateway_interface = 0
      shared_secret         = module.vpn_mgmt_to_prod.random_secret
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.20.2"
        asn     = 64519
      }
      bgp_session_range     = "169.254.20.1/30"
      ike_version           = 2
      vpn_gateway_interface = 1
      shared_secret         = module.vpn_mgmt_to_prod.random_secret
    }
  }
}