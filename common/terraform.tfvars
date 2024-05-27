project_id = "convrt-common"
region     = "europe-west3"
bucket_names = [
  "convrt-extension",
  #"convrt-fe-dev",
  "convrt-fe-preprod",
  "convrt-fe-prod-eu",
  "convrt-media-store",
  "convrt-tg-profilepic",
  "convrt-instagram-profiles"
]

#################
### Cloud SQL ###
#################
sql = {
  engine                = "postgresql",
  instance_name         = "connectplus",
  db_name               = "convrt",
  database_version      = "POSTGRES_15",
  tier                  = "db-custom-2-8192",
  zone                  = "europe-west3-a",
  disk_size             = "100"
}
sql_network = {
  name               = "vpc-common",
  allocated_ip_range = "ga-vpc-common-vpc-peering-internal"
}
sql_backup_configuration = {
  enabled                        = true,
  location                       = "europe-west3",
  point_in_time_recovery_enabled = true,
  transaction_log_retention_days = 7,
  start_time                     = "21:30",
  backup_retention_settings = {
    retained_backups = 7
  }
}

#################
### Cloud Run ###
#################
cr_services = {
  "connectplus" = {
    create_sa = true
    elb_config = {
      ssl                             = true
      managed_ssl_certificate_domains = ["connectplus-api-g.convrt.io"]
      https_redirect                  = true
    }
  }

  "connectplus-bg" = {
    create_sa = true
    elb_config = {
      ssl                             = false
      managed_ssl_certificate_domains = []
      https_redirect                  = false
    }
  }
}

################
### Frontend ###
################
frontend_dev = {
  bucket_name = "convrt-fe-dev"
  ssl = {
    enable       = true
    domains      = ["dev-app-g.convrt.io"]
  }
}

##################
### Gitlab WIF ###
##################
gitlab_wif = {
  gitlab_namespace_id = "67201378"
  gitlab_sa_permissions = [
    "convrt-common=>roles/iam.workloadIdentityUser",
    "convrt-common=>roles/artifactregistry.writer",
    "convrt-common=>roles/run.developer",
    "convrt-common=>roles/storage.admin"
    ]
}