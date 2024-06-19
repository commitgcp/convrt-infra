project_id = "convrt-common"
region     = "europe-west3"
bucket_names = [
  "convrt-extension",
  #"convrt-fe-dev",
  #"convrt-fe-preprod",
  #"convrt-fe-prod-eu",
  "convrt-media-store",
  "convrt-tg-profilepic",
  "convrt-instagram-profiles"
]

#######################
### CDN for Buckets ###
#######################

buckets_for_cdn = [
  {
    name = "convrt-extension",
    ssl = {
      enable  = false
      domains = []
    }
  },
  {
    name = "convrt-media-store",
    ssl = {
      enable  = false
      domains = []
    }
  }
]

#################
### Cloud SQL ###
#################
sql = {
  engine           = "postgresql",
  instance_name    = "connectplus",
  db_name          = "convrt",
  database_version = "POSTGRES_15",
  tier             = "db-custom-2-8192",
  zone             = "europe-west3-a",
  disk_size        = "100"
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
      managed_ssl_certificate_domains = ["connectplus-api.convrt.io"]
      https_redirect                  = true
    }
  }

  "connectplus-bg" = {
    create_sa = true
    elb_config = {
      ssl                             = false
      managed_ssl_certificate_domains = []
      https_redirect                  = false
      connection_draining_timeout_sec = 300
    }
  }
}

################
### Frontend ###
################
frontend_dev = {
  bucket_name                = "convrt-fe-dev"
  forwarding_rule_name       = "http-lb-url-map-convrt-fe-de-2-forwarding-rule"
  forwarding_rule_name_https = "http-lb-url-map-convrt-fe-dev-forwarding-rule-2"
  target_https_proxy_name    = "http-lb-url-map-convrt-fe-dev-target-proxy-2"
  target_http_proxy_name     = "http-lb-url-map-convrt-fe-de-2-target-proxy"
  url_map_name               = "http-lb-url-map-convrt-fe-de-2-redirect"
  url_map_https              = "http-lb-url-map-convrt-fe-dev"
  ssl = {
    enable  = true
    domains = ["dev-app.convrt.io"]
  }
}

frontend_preprod = {
  bucket_name                = "convrt-fe-preprod"
  forwarding_rule_name       = "http-lb-url-map-convrt-fe-pr-2-forwarding-rule-2"
  forwarding_rule_name_https = "http-lb-url-map-convrt-fe-prep-forwarding-rule-2"
  target_https_proxy_name    = "http-lb-url-map-convrt-fe-prep-target-proxy-2"
  target_http_proxy_name     = "http-lb-url-map-convrt-fe-pr-2-target-proxy-2"
  url_map_name               = "http-lb-url-map-convrt-fe-pr-2-redirect-2"
  url_map_https              = "http-lb-url-map-convrt-fe-preprod"
  ssl = {
    enable  = true
    domains = ["preprod-app.convrt.io", "app.convrt.ai"]
  }
}

frontend_prod = {
  bucket_name                = "convrt-fe-prod-eu"
  forwarding_rule_name       = "http-lb-url-map-convrt-fe-pr-2-forwarding-rule"
  forwarding_rule_name_https = "http-lb-url-map-convrt-fe-prod-forwarding-rule-2"
  target_https_proxy_name    = "http-lb-url-map-convrt-fe-prod-target-proxy-2"
  target_http_proxy_name     = "http-lb-url-map-convrt-fe-pr-2-target-proxy"
  url_map_name               = "http-lb-url-map-convrt-fe-pr-2-redirect"
  url_map_https              = "http-lb-url-map-convrt-fe-prod-eu"
  ssl = {
    enable  = true
    domains = ["app.convrt.io"]
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