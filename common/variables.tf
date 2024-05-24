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

variable "sql" {
  description = "sql config"
  type = object({
    engine            = optional(string, "postgresql")
    instance_name     = string
    db_name           = string
    database_version  = string
    tier              = string
    zone              = string
    availability_type = string
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
