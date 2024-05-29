###############
### General ###
###############
project_id = "preprod-423309"
region     = "europe-west3"

#################
### Cloud SQL ###
#################
sql = {
  engine            = "postgresql",
  instance_name     = "convrt-db-preprod",
  db_name           = "convrt",
  database_version  = "POSTGRES_14",
  tier              = "db-custom-4-8192",
  zone              = "europe-west3-a",
  availability_type = "ZONAL",
  disk_size         = "400"
}

sql_network = {
  name               = "vpc-preprod",
  allocated_ip_range = "ga-vpc-preprod-vpc-peering-internal"
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
  "convrt-api-service-preprod" = {
    create_sa = true
    elb_config = {
      ssl                             = true
      managed_ssl_certificate_domains = ["preprod-api-g.convrt.io"]
      https_redirect                  = true
    }
  }
}