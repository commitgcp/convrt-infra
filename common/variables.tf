###############
### General ###
###############
variable "project_id" {
  description = "GCP project ID"
}

variable "region" {
  description = "Default GCP region"
}

variable "bucket_names" {
  description = "A list of bucket names"
  type        = list(string)
}

#################
### Cloud SQL ###
#################
variable "sql" {
  description = "sql config"
  type = object({
    engine            = optional(string, "postgresql")
    instance_name     = string
    db_name           = string
    database_version  = string
    tier              = string
    zone              = string
    availability_type = optional(string, "REGIONAL")
    disk_size         = string
  })
}

variable "sql_network" {
  type = object({
    name               = string
    allocated_ip_range = string
  })
}

variable "sql_backup_configuration" {
  type = object({
    binary_log_enabled             = optional(bool)
    enabled                        = optional(bool)
    start_time                     = optional(string)
    point_in_time_recovery_enabled = optional(bool)
    location                       = optional(string)
    transaction_log_retention_days = optional(number)
    backup_retention_settings = optional(object({
      retained_backups = optional(number)
      retention_unit   = optional(string)
    }))
  })
  default = {}
}

#################
### Cloud Run ###
#################
variable "cr_services" {
  type = map(object({
    create_sa     = optional(bool, false)
    sa_permission = optional(list(string), [])
    elb_config = optional(object({
      enable_cdn                      = optional(bool, false)
      ssl                             = optional(bool, false)
      managed_ssl_certificate_domains = optional(list(string), [])
      https_redirect                  = optional(bool, false)
      log_config = optional(object({
        enable      = optional(bool, false)
        sample_rate = optional(number, 1.0)
      }))
      iap_config = optional(object({
        enable               = optional(bool, false)
        oauth2_client_id     = optional(string)
        oauth2_client_secret = optional(string)
      }))
    }))
  }))
}

################
### Frontend ###
################
variable "frontend_dev" {
  type = object({
    bucket_name            = string
    backend_name           = optional(string)
    website_main_page_file = optional(string, "index.html")
    website_not_found_page = optional(string, "404.html")
    cors = optional(object({
      origin          = list(string)
      method          = list(string)
      response_header = list(string)
      max_age_seconds = number
    }), null)
    certificates = optional(list(string), [])
  })
}

##################
### Gitlab WIF ###
##################
variable "gitlab_wif" {
    type = object({
        gitlab_namespace_id = string
        gitlab_sa_permissions = list(string)
    })
}