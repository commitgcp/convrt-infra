###############
### General ###
###############
variable "project_id" {
  type        = string
  description = "Network project ID"
}

variable "parent" {
  type        = string
  description = "Network project parent (folder)"
  default     = "fldr-common"
}

#variable "org_id" {
#  type        = string
#  description = "Organization ID"
#}

variable "region" {
  type        = string
  description = "Default region"
}

###########
### VPC ###
###########
variable "vpc" {
  type = map(object({
    delete_default_internet_gateway_routes = optional(bool, false)
    description                            = optional(string)
    routing_mode                           = optional(string, "GLOBAL")
    project_id                             = optional(string)
    auto_create_subnetworks                = optional(bool, false)
    mtu                                    = optional(number, 1460)
    external_services_vpc_peering = optional(list(object({
      vpc                  = string
      project              = string
      import_custom_routes = optional(bool, true)
      export_custom_routes = optional(bool, true)
      })
    ), [])
  }))
  description = <<-EOT
    VPC Configuration
    vpc1 = {
        delete_default_internet_gateway_routes = string (default true),
        description = string (default ""),
        auto_create_subnetworks = string (default true),
        routing_mode = string (default "GLOBAL"),
        mtu = number (default 1460),
        project_id = string (default var.project_id)
    },
    vpc2 = {...}
    vpc3 = {...}
  EOT
}

variable "hub_network" {
  type        = string
  description = "Name of the Hub Network (optional)"
  default     = null
}

variable "spoke_networks" {
  type        = list(string)
  description = "List of spoke network peer to the hub Network (optional)"
  default     = []
}

variable "private_service_access" {
  type        = map(string)
  description = "Key is VPC network and value is CIDR used for private service access (for example SQL)"
  default     = {}
}

###############
### Subnets ###
###############
variable "subnets" {
  type = map(list(object({
    subnet_name               = string
    subnet_ip                 = string
    subnet_region             = optional(string)
    description               = optional(string, "")
    subnet_private_access     = optional(bool, false)
    subnet_flow_logs          = optional(bool, false)
    subnet_flow_logs_interval = optional(string, "INTERVAL_5_SEC")
    subnet_flow_logs_sampling = optional(number, 0.5)
    subnet_flow_logs_metadata = optional(string, "INCLUDE_ALL_METADATA")
    subnet_flow_logs_filter   = optional(bool, true)
    purpose                   = optional(string),
    role                      = optional(string),
  })))
  description = <<-EOT
    The list of subnets being created per VPC

    Subnet Configuration
    vpc-x = [
        {
            subnet_name            = string
            subnet_ip              = string
            subnet_region          = string (default "")
            description            = string (default "")
            subnet_private_access  = bool (default false)

            subnet_flow_logs          = bool (default false)
            subnet_flow_logs_interval = string (default "INTERVAL_5_SEC")
            subnet_flow_logs_sampling = number (default 0.5)
            subnet_flow_logs_metadata = string (default "INCLUDE_ALL_METADATA")
            subnet_flow_logs_filter   = boold (default true)

            purpose                = string (default null, options: "INTERNAL_HTTPS_LOAD_BALANCER")
            role                   = string (default null, options: ACTIVE or BACKUP. Only used when purpose is INTERNAL_HTTPS_LOAD_BALANCER)
        },
        {
            subnet_name = ...
        }
    ],

    vpc-z = [...]
  EOT
  default     = {}
}

variable "secondary_ranges" {
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  description = <<-EOT
    Optional secondary ranges for some subnets

    Secondary subnet configuration
    {
        subnet-x = [
            {
                range_name            = string
                ip_cidr_range         = string
            },
            {
                range_name            = string
                ip_cidr_range         = string
            },
            ...
        ],
        subnet-y = [...]
    }    

    vpc-z = [...]
  EOT
  default     = {}
}

##############
### Routes ###
##############
variable "default_routes" {
  type = list(object({
    name                   = string
    description            = optional(string)
    tags                   = optional(string, "")
    destination_range      = optional(string)
    next_hop_internet      = optional(bool, false)
    next_hop_ip            = optional(string)
    next_hop_instance      = optional(string)
    next_hop_instance_zone = optional(string)
    next_hop_vpn_tunnel    = optional(string)
    next_hop_ilb           = optional(string)
    priority               = optional(string)
  }))
  description = <<-EOT
    The list of default routes to create to ALL VPCs

    Route Configuration
    [
        {
            name                   = string
            description            = string (default null)
            tags                   = string (default "")
            destination_range      = string (default null)
            next_hop_internet      = bool (default false)
            next_hop_ip            = string (default null)
            next_hop_instance      = string (default null)
            next_hop_instance_zone = string (default null)
            next_hop_vpn_tunnel    = string (default null)
            next_hop_ilb           = string (default null)
            priority               = string (default null)
        }
    ]
  EOT


  default = [
    {
      name              = "rt-egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    },
    {
      name              = "rt-windows-kms"
      description       = "route through IGW to GCP windows KMS"
      destination_range = "35.190.247.13/32"
      next_hop_internet = "true"
    }
  ]
}

variable "routes" {
  type = map(list(object({
    name                   = string
    description            = optional(string)
    tags                   = optional(string, "")
    destination_range      = optional(string)
    next_hop_internet      = optional(bool, false)
    next_hop_ip            = optional(string)
    next_hop_instance      = optional(string)
    next_hop_instance_zone = optional(string)
    next_hop_vpn_tunnel    = optional(string)
    next_hop_ilb           = optional(string)
    priority               = optional(string)
  })))
  description = "List of routes being created per VPC. Map Key is VPC name, value is route list (see default_routes configuration/example)"
  default     = {}
}

################
### Firewall ###
################
variable "firewall_rules" {
  type = map(list(object({
    name                    = string
    description             = optional(string)
    direction               = string
    priority                = optional(number)
    ranges                  = optional(list(string))
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    allow = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])
    log_config = optional(object({
      metadata = string
    }))
  })))

  description = <<-EOT
    The list of firewall rules being created per VPC

    Firewall rule configuration

    vpc-x = [
        {
            name                    = string
            description             = string (default null)
            direction               = string (INGRESS OR EGRESS)
            priority                = number (default null)
            ranges                  = list(string) (default null)
            source_tags             = list(string) (default null)
            source_service_accounts = list(string) (default null)
            target_tags             = list(string) (default null)
            target_service_accounts = list(string) (default null)
            allow = list(object({
              protocol = string
              ports    = list(string)
            })) (default [])
            deny = list(object({
              protocol = string
              ports    = list(string)
            })) (default [])
            log_config = object({
              metadata = string
            }) (default null)
        },
        {
            name = firewall2...
        }
    ],

    vpc-z = [...]
  EOT

  default = {}
}

###########
### NAT ###
###########
variable "nat" {
  type = map(object({
    region                             = optional(string)
    min_ports_per_vm                   = optional(number, 64)
    network                            = string
    router                             = string
    router_asn                         = optional(number, 64514)
    log_config_enable                  = optional(bool, false)
    log_config_filter                  = optional(string, "ALL")
    number_static_addresses            = optional(number, 0)
    source_subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS_ALL_IP_RANGES")
    subnetworks = optional(list(object({
      name                     = string,
      source_ip_ranges_to_nat  = list(string)
      secondary_ip_range_names = list(string)
    })), [])

  }))
  description = <<-EOT
    The list of NATs being created per VPC

    NAT configuration

    nat-x =
        {
            region            = string
            min_ports_per_vm  = number (default 64)
            network           = string
            router            = string (router name)
            router_asn        = number (default 64514)
            log_config_enable = bool (default false)

            log_config_filter = string (default ALL, options: ERRORS_ONLY, TRANSLATIONS_ONLY, ALL)

            number_static_addresses            = number (default 0)
            source_subnetwork_ip_ranges_to_nat = string (default ALL_SUBNETWORKS_ALL_IP_RANGES, options: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS)
            subnetworks = list(object({
              name                     = string,
              source_ip_ranges_to_nat  = list(string)
              secondary_ip_range_names = list(string)
            })) (default [])
        }

    nat-z = {...}
  EOT
  default     = {}
}

###########
### DNS ###
###########
variable "dns" {
  type = map(object({
    type   = optional(string, "private")
    domain = string

    target_name_server_addresses = optional(list(map(string)), [])

    target_network                     = optional(string, "")
    private_visibility_config_networks = optional(list(string), [])

    #"Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details"
    # Follow DNS module repository, because implementation should be changed to use object instead of map of any
    dnssec_config = optional(any, {})

    default_key_specs_key = optional(object({
      algorithm  = optional(string, "rsasha256")
      key_length = optional(number, 2048)
      key_type   = optional(string, "keySigning")
      kind       = optional(string, "dns#dnsKeySpec")
    }))

    default_key_specs_zone = optional(object({
      algorithm  = optional(string, "rsasha256")
      key_length = optional(number, 1024)
      key_type   = optional(string, "zoneSigning")
      kind       = optional(string, "dns#dnsKeySpec")
    }))
  }))
  description = <<-EOT
    The list of DNSs being created.

    DNS configuration

    dns-x =
        {
            type              = string (Options: 'public', 'private', 'forwarding', 'peering')
            domain            = string

            target_name_server_addresses = string (When type 'forwarding', configuration: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone#target_name_servers)
            target_network = string (When type 'peering, The id or fully qualified URL of the VPC network to forward queries to)
            private_visibility_config_networks = list(string) (List of VPC that can see this zone.)

            dnssec_config = any (Optional, further information https://github.com/terraform-google-modules/terraform-google-cloud-dns)
            default_key_specs_key = any (Optional, further information https://github.com/terraform-google-modules/terraform-google-cloud-dns)
            default_key_specs_zone = any (Optional, further information https://github.com/terraform-google-modules/terraform-google-cloud-dns)
        }

    dns-z = {...}
  EOT
  default     = {}
}

variable "recordsets" {
  type = map(list(object({
    name    = optional(string, "")
    type    = string
    ttl     = optional(number)
    records = optional(list(string), [])
  })))
  description = "List of DNS record objects to manage, in the standard terraform dns structure."
  default     = {}
}
