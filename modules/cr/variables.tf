###############
### General ###
###############
variable "project" {
  type = string
}

variable "region" {
  description = "Cloud Run Region"
  type        = string
}

#################
### Cloud Run ###
#################
variable "service" {
  description = "Cloud Run Service"
  type        = string
}

variable "image" {
  description = "Cloud Run image"
  type        = string
  default     = "gcr.io/cloudrun/hello"
}

variable "request_timeout_seconds" {
  description = "The max duration the instance is allowed for responding to a request"
  type        = number
  default     = 300
}

# variable "env_vars" {
#   type        = map(string)
#   description = "Environment variables (cleartext). Key is Environment variable name and value is env variable value"
#   default     = {}
# }

variable "ingress" {
  type        = string
  description = "Acceptable values all, internal, internal-and-cloud-load-balancing"
  default     = "internal-and-cloud-load-balancing"
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated cloud run invocations"
  type        = bool
  default     = true
}

variable "protocol" {
  description = "Port protocol to use. Options http1 or h2c (grpc)"
  type        = string
  default     = "http1"
}

variable "port" {
  description = "Port which the container listens to"
  type        = number
}

variable "limits" {
  type = object({
    cpu    = string
    memory = string
  })
  description = "Resource limits to the container. cpu = (core count * 1000)m, memory = (size) in Mi/Gi"
  default = {
    cpu    = "1000m"
    memory = "128Mi"
  }
}

# variable "env_secret_vars" {
#   type        = map(string)
#   description = "Secret environment variables (From Secret Manager). Key is Environment variable name and value is secret manager secret name"
#   default     = {}
# }

# variable "template_annotations" {
#   type        = map(string)
#   description = "Annotations to the container metadata including VPC Connector and SQL. See [more details](https://cloud.google.com/run/docs/reference/rpc/google.cloud.run.v1#revisiontemplate)"
#   default = {
#     "run.googleapis.com/client-name"   = "terraform"
#     "generated-by"                     = "terraform"
#     "autoscaling.knative.dev/maxScale" = 2
#     "autoscaling.knative.dev/minScale" = 1
#   }
# }

variable "container_concurrency" {
  type        = number
  description = "Container concurrency. Number of request to process per container"
  default     = 80
}

###########
### IAM ###
###########
variable "create_sa" {
  description = "Create service account for Cloud Run service"
  type        = bool
  default     = false
}

variable "sa_permission" {
  description = "Service Account (if created) permission"
  type        = list(string)
  default     = []
}

##############################
### External Load Balancer ###
##############################
variable "elb_config" {
  description = "Cloud Run Service to attach External Load Balancer"
  type = object({
    enable_cdn                      = optional(bool, false)
    ssl                             = optional(bool, false)
    managed_ssl_certificate_domains = optional(list(string), [])
    https_redirect                  = optional(bool, false)
    log_config = optional(object({
      enable      = optional(bool, false)
      sample_rate = optional(number, 1.0)
    }), {
      enable = false
      sample_rate = 1.0
    })

    iap_config = optional(object({
      enable               = optional(bool, false)
      oauth2_client_id     = optional(string)
      oauth2_client_secret = optional(string)
    }),
     {
      enable = false
    })
  })

  default = null
}

##############################
### Internal Load Balancer ###
##############################
variable "ilb_config" {
  description = "Cloud Run Service to attach internal Load Balancer"
  type = object({
    network    = string
    subnetwork = string
  })

  default = null
}