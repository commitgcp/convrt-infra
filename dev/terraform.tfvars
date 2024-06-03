###############
### General ###
###############
project_id = "convrt-dev"
region     = "europe-west3"

#################
### Cloud SQL ###
#################
sql = {
  engine            = "postgresql",
  instance_name     = "convrt-db-dev",
  db_name           = "convrt",
  database_version  = "POSTGRES_13",
  tier              = "db-custom-4-16384",
  zone              = "europe-west3-a",
  availability_type = "ZONAL",
  disk_size         = "1000"
}

sql_network = {
  name               = "vpc-dev",
  allocated_ip_range = "ga-vpc-dev-vpc-peering-internal"
}

sql_backup_configuration = {
  enabled                        = true,
  location                       = "europe-west3",
  point_in_time_recovery_enabled = true,
  transaction_log_retention_days = 7,
  start_time                     = "08:16",
  backup_retention_settings = {
    retained_backups = 7
  }
}

#################
### Cloud Run ###
#################
cr_services = {
  "convrt-api-service-dev" = {
    create_sa = true
    elb_config = {
      ssl                             = true
      managed_ssl_certificate_domains = ["dev-api.convrt.io"]
      https_redirect                  = true
    }
  }
}