###############
### General ###
###############
variable "project_id" {
  type        = string
  description = "Network project ID"
}

################
### CDN + LB ###
################
variable "bucket" {
  type        = string
  description = "Bucket to enable CDN"
}

variable "backend_name" {
  type = string
  description = "Backend name"
  default = null
}

variable "http_forwarding_rule_name" {
  type = string
  description = "HTTP forwarding rule name"
  default = null
}

variable "https_forwarding_rule_name" {
  type = string
  description = "HTTPs forwarding rule name"
  default = null
}

variable "load_balancing_scheme" {
  type = string
  description = "Load balancing scheme"
  default = "EXTERNAL"
}

variable "http_target_proxy" {
  type = string
  description = "HTTP target proxy name"
  default = null
}

variable "https_target_proxy" {
  type = string
  description = "HTTPs target proxy name"
  default = null
}

variable "http_url_map" {
  type = string
  description = "HTTP URL map name"
  default = null
}

variable "https_url_map" {
  type = string
  description = "HTTPs URL map name"
  default = null
}

variable "cdn" {
  description = "CDN configuration"
  type = object({
    enable            = optional(bool, false)
    cache_mode        = optional(string, "CACHE_ALL_STATIC")
    client_ttl        = optional(number, 3600)
    default_ttl       = optional(number, 3600)
    max_ttl           = optional(number, 86400)
    negative_caching  = optional(bool, true)
    serve_while_stale = optional(number, 86400)
    request_coalescing = optional(bool, true)
  })
  default = {
    enable = false
  }
}

variable "ssl" {
  description = "SSL configuration"
  type = object({
    enable       = optional(bool, false)
    certificates = optional(list(string), [])
  })
  default = {
    enable = false
  }
}