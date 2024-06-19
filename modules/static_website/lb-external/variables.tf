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

variable "forwarding_rule_name" {
  type        = string
  description = "Forwarding rule name"
}

variable "forwarding_rule_name_https" {
  type        = string
  description = "Forwarding rule name for HTTPS"
}

variable "target_http_proxy_name" {
  type        = string
  description = "Target HTTP proxy name for HTTPS"
}

variable "target_https_proxy_name" {
  type        = string
  description = "Target HTTPs proxy name for HTTPS"
}

variable "url_map_name" {
  type        = string
  description = "URL map name"
}

variable "url_map_https" {
  type        = string
  description = "URL map name for HTTPS"
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
  })
  default = {
    enable = false
  }
}

variable "ssl" {
  description = "SSL configuration"
  type = object({
    enable  = optional(bool, false)
    cert    = optional(string)
    key     = optional(string)
    domains = optional(list(string), [])
  })
  default = {
    enable = false
  }
}