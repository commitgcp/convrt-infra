###############
### General ###
###############
variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "service" {
  description = "Cloud Run service to attach external load balancer"
  type        = string
}

variable "elb_config" {
  description = "External Load Balancer configuration"
  type = object({
    enable_cdn                      = optional(bool, false)
    ssl                             = optional(bool, false)
    managed_ssl_certificate_domains = optional(list(string), [])
    https_redirect                  = optional(bool, false)
    connection_draining_timeout_sec = optional(number, 0)
    log_config = optional(object({
      enable      = optional(bool, false)
      sample_rate = optional(number, 1.0)
    }))

    iap_config = optional(object({
      enable               = optional(bool, false)
      oauth2_client_id     = optional(string)
      oauth2_client_secret = optional(string)
    }))
  })
}
