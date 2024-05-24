###############
### General ###
###############
variable "region" {
  description = "Default GCP region"
}

#variable "org_id" {
#  type        = string
#  description = "Organization ID"
#}

###########
### VPC ###
###########
variable "vpc" {
  type = map(map(object({
    delete_default_internet_gateway_routes = optional(bool, false)
    description                            = optional(string)
    routing_mode                           = optional(string, "GLOBAL")
    project_id                             = optional(string)
    auto_create_subnetworks                = optional(bool, false)
    mtu                                    = optional(number, 1460)
  })))
  description = <<-EOT
    VPC Configuration
    
    VPN Configuration:
    project1 = {
      vpc1 = {
          delete_default_internet_gateway_routes = string (default true),
          description = string (default ""),
          auto_create_subnetworks = string (default true),
          routing_mode = string (default "GLOBAL"),
          mtu = number (default 1460),
          project_id = string (default var.project_id)
      },
      vpc2 = {...}
    }
    project1 = {
      vpc3 = {...}
    }
  EOT
}

###############
### Subnets ###
###############
variable "subnets" {
  type = map(map(list(object({
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
  }))))
  description = <<-EOT
    The list of subnets being created per VPC

    Subnet Configuration
    project1 = {
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
    }

  project2 = {
    vpc-y = [...]
  }
  EOT
  default     = {}
}


#######################
### Hub Spoke (VPN) ###
#######################
variable "vpn_mgmt_dev" {
  type = object({
    mgmt_project_id = string
    dev_project_id  = string
    mgmt_network    = string
    dev_network     = string
  })
}

variable "vpn_mgmt_preprod" {
  type = object({
    mgmt_project_id    = string
    preprod_project_id = string
    mgmt_network       = string
    preprod_network    = string
  })
}

variable "vpn_mgmt_prod" {
  type = object({
    mgmt_project_id = string
    prod_project_id = string
    mgmt_network    = string
    prod_network    = string
  })
}

###########
### NAT ###
###########
variable "nat" {
  type = map(map(object({
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
  })))
  description = <<-EOT
    The list of NATs being created per VPC

    NAT configuration
    project1 = {
      nat-x =
          {
              region            = optional(string)
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
    }

    project2 = {
      nat-y = {...}
    }  
  EOT
  default     = {}
}

################
### Firewall ###
################
variable "firewall" {
  type = map(map(list(object({
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
  }))))

  description = <<-EOT
    The list of firewall rules being created per VPC

    Firewall rule configuration

    project1 = {
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
    }
  EOT
  default     = {}
}

#############################
### Hierarchical Firewall ###
#############################
variable "hierarchical_firewall" {
  description = "Key is hierarchical firewall name, value is configuration"
  type = map(object({
    parent       = optional(string)
    associations = optional(list(string), [])
    rules = map(object({
      description             = string
      direction               = string
      action                  = string
      priority                = number
      ranges                  = list(string)
      ports                   = map(list(string))
      target_service_accounts = optional(list(string))
      target_resources        = optional(list(string))
      logging                 = optional(bool, false)
    }))
    }
  ))

  default = {
    "default" = {
      rules = {
        delegate-rfc1918-ingress = {
          description = "Delegate RFC1918 ingress"
          direction   = "INGRESS"
          action      = "goto_next"
          priority    = 500
          ranges = [
            "192.168.0.0/16",
            "10.0.0.0/8",
            "172.16.0.0/12"
          ]
          ports = { "all" = [] }
        }
        delegate-rfc1918-egress = {
          description = "Delegate RFC1918 egress"
          direction   = "EGRESS"
          action      = "goto_next"
          priority    = 510
          ranges = [
            "192.168.0.0/16",
            "10.0.0.0/8",
            "172.16.0.0/12"
          ]
          ports = { "all" = [] }
        }
        allow-iap-ssh-rdp = {
          description = "Always allow SSH from IAP"
          direction   = "INGRESS"
          action      = "allow"
          priority    = 5000
          ranges      = ["35.235.240.0/20"]
          ports = {
            tcp = ["22"]
          }
          logging = true
        }
        allow-google-hbs-and-hcs = {
          description = "Always allow connections from Google load balancer and health check ranges"
          direction   = "INGRESS"
          action      = "allow"
          priority    = 5200
          ranges = [
            "35.191.0.0/16",
            "130.211.0.0/22",
            "209.85.152.0/22",
            "209.85.204.0/22"
          ]
          ports = {
            tcp = ["80", "443"]
          }
          logging = true
        }
        allow-mgmt- = {
          description = "Always allow mgmt or hub VPC to communicate with spoke VPCs"
          direction   = "INGRESS"
          action      = "allow"
          priority    = 450
          ranges = [
            "10.21.0.0/25"
          ]
          ports   = { "all" = [] }
          logging = true
        }
      }
    }
  }
}

##############################################
### Private Service Access (For Cloud SQL) ###
##############################################
variable "private_service_access" {
  type        = map(map(string))
  description = "Key is project ID. Value is another map with key VPC network and value CIDR used for private service access (for example SQL)"
  default     = {}
}

###########
### DNS ###
###########
variable "dns" {
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
  type = map(map(object({
    type   = optional(string, "private")
    domain = string

    target_name_server_addresses = optional(list(map(string)), [])

    target_network                     = optional(string, "")
    private_visibility_config_networks = optional(list(string), [])

    dnssec_config = optional(object({
      kind          = optional(string, "dns#managedZoneDnsSecConfig")
      non_existence = optional(string, "nsec3")
      state         = optional(string, "off")
    }))

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
  })))
  default = {}
}

variable "recordsets" {
  description = "List of DNS record objects to manage, in the standard terraform dns structure."
  type = map(map(list(object({
    name    = optional(string, "")
    type    = string
    ttl     = optional(number, 300)
    records = optional(list(string), [])
  }))))
  default = {}
}
