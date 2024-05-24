###########
### IAM ###
###########
resource "google_service_account" "cloud_run" {
  count        = var.create_sa ? 1 : 0
  project      = var.project
  account_id   = "cr-${var.service}"
  display_name = "Cloud Run ${var.service} service account"
}

resource "google_project_iam_member" "cloud_run" {
  for_each = var.create_sa ? toset(var.sa_permission) : []
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.cloud_run[0].email}"
}

#################
### Cloud Run ###
#################
resource "google_cloud_run_service" "default" {
  name     = "${var.service}"
  location = var.region
  project  = var.project

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = var.ingress
    }
  }

  template {
    # metadata {
    #   annotations = var.template_annotations
    # }

    spec {
      container_concurrency = var.container_concurrency
      service_account_name  = var.create_sa ? google_service_account.cloud_run[0].email : null
      timeout_seconds       = var.request_timeout_seconds
      containers {
        image = var.image
        ports {
          name           = var.protocol
          container_port = var.port
        }

        # resources {
        #   limits = var.limits
        # }

        # dynamic "env" {
        #   for_each = var.env_vars
        #   content {
        #     name  = env.key
        #     value = env.value
        #   }
        # }

        # dynamic "env" {
        #   for_each = var.env_secret_vars
        #   content {
        #     name = env.key
        #     value_from {
        #       secret_key_ref {
        #         name = env.value
        #         key  = "latest"
        #       }
        #     }
        #   }
        # }

      }
    }
  }
  autogenerate_revision_name = true

  # lifecycle {
  #   ignore_changes = [
  #     template[0].spec[0].containers[0].image,
  #   ]
  # }
  lifecycle {
    ignore_changes = [
      traffic,
      template,
      metadata
    ]
  }
}

###############
### No Auth ###
###############
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  count    = var.allow_unauthenticated ? 1 : 0
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

##############################
### External Load Balancer ###
##############################
module "elb" {
  count      = var.elb_config != null ? 1 : 0
  source     = "./lb/external"
  project    = var.project
  region     = var.region
  service    = "${var.service}"
  elb_config = var.elb_config
}
