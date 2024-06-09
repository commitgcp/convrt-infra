###############
### General ###
###############
project_id = "convrt-prod"
region     = "europe-west3"

#################
### Cloud SQL ###
#################
sql = {
  engine            = "postgresql",
  instance_name     = "convrt-db-prod",
  db_name           = "convrt",
  database_version  = "POSTGRES_14",
  tier              = "db-custom-4-16384",
  zone              = "europe-west3-a",
  availability_type = "REGIONAL",
  disk_size         = "400"
}

sql_network = {
  name               = "vpc-prod",
  allocated_ip_range = "ga-vpc-prod-vpc-peering-internal"
}

sql_backup_configuration = {
  enabled                        = true,
  location                       = "europe-west3",
  point_in_time_recovery_enabled = true,
  transaction_log_retention_days = 7,
  start_time                     = "10:26",
  backup_retention_settings = {
    retained_backups = 7
  }
}

#################
### Cloud Run ###
#################
cr_services = {
  "convrt-api-service-prod" = {
    create_sa = true
    elb_config = {
      ssl                             = true
      managed_ssl_certificate_domains = ["api.convrt.io"]
      https_redirect                  = true
    }
  }
}