##############################
### Cloud SQL - Postgresql ###
##############################
module "postgresql" {
  source           = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name             = var.sql.instance_name
  project_id       = var.project
  database_version = var.sql.database_version
  region           = var.region
  disk_size        = var.sql.disk_size

  // Master configurations
  tier              = var.sql.tier
  zone              = var.sql.zone
  availability_type = "REGIONAL"

  deletion_protection = true
  enable_default_db   = false

  ip_configuration = {
    ipv4_enabled        = var.network.enable_public_ip
    require_ssl         = var.network.require_ssl
    private_network     = var.network.name == null ? null : "projects/${var.project}/global/networks/${var.network.name}"
    allocated_ip_range  = var.network.allocated_ip_range
    authorized_networks = var.network.authorized_networks
  }

  db_name          = var.sql.db_name
  additional_users = var.additional_users

  backup_configuration = {
    enabled                        = var.backup_configuration.enabled
    start_time                     = var.backup_configuration.start_time
    location                       = var.backup_configuration.location
    point_in_time_recovery_enabled = var.backup_configuration.point_in_time_recovery_enabled
    transaction_log_retention_days = var.backup_configuration.transaction_log_retention_days
    retained_backups               = var.backup_configuration.retained_backups
    retention_unit                 = var.backup_configuration.retention_unit
  }
}