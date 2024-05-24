###############
### General ###
###############
variable "project" {
  type        = string
  description = "The project ID to deploy resources into"
}

variable "region" {
  description = "The region to deploy resources into"
  type        = string
}

#################
### Cloud SQL ###
#################
variable "sql" {
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

variable "network" {
  type = object({
    name             = optional(string)
    enable_public_ip = optional(bool, true)
    require_ssl      = optional(bool, true)
    authorized_networks = optional(list(object({
      name  = string
      value = string
    })), [])
    allocated_ip_range = optional(string)
  })
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = bool
    start_time                     = optional(string)
    location                       = optional(string)
    point_in_time_recovery_enabled = optional(bool, false)
    transaction_log_retention_days = optional(string)
    retained_backups               = optional(number)
    retention_unit                 = optional(string)
  })
  default = {
    enabled = false
  }
}

variable "additional_users" {
  description = "A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set."
  type = list(object({
    name            = string
    password        = string
    random_password = bool
  }))
  default = []
  validation {
    condition     = length([for user in var.additional_users : false if(user.random_password == false && (user.password == null || user.password == "")) || (user.random_password == true && (user.password != null && user.password != ""))]) == 0
    error_message = "Password is a requird field for built_in Postgres users and you cannot set both password and random_password, choose one of them."
  }
}