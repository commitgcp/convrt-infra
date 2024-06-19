###############
### GENERAL ###
###############
variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

##############
### BUCKET ###
##############
variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
}

variable "backend_name" {
  type        = string
  description = "Backend name"
  default     = null
}

variable "http_forwarding_rule_name" {
  type        = string
  description = "HTTP forwarding rule name"
  default     = null
}

variable "https_forwarding_rule_name" {
  type        = string
  description = "HTTPs forwarding rule name"
  default     = null
}

variable "http_target_proxy" {
  type        = string
  description = "HTTP target proxy name"
  default     = null
}

variable "https_target_proxy" {
  type        = string
  description = "HTTPs target proxy name"
  default     = null
}

variable "http_url_map" {
  type        = string
  description = "HTTP URL map name"
  default     = null
}

variable "https_url_map" {
  type        = string
  description = "HTTPs URL map name"
  default     = null
}

variable "bucket_location" {
  description = "The location of the bucket"
  type        = string
}

variable "bucket_storage_class" {
  description = "The storage class of the bucket"
  type        = string
  default     = "STANDARD"
}

variable "bucket_labels" {
  description = "The labels of the bucket"
  type        = map(string)
  default     = {}
}

variable "bucket_versioning_enabled" {
  description = "The versioning of the bucket"
  type        = bool
  default     = true
}

variable "website_main_page_file" {
  description = "The main page of the bucket"
  type        = string
  default     = "index.html"
}

variable "website_not_found_page" {
  description = "The not found page of the bucket"
  type        = string
  default     = "404.html"
}

variable "cors" {
  description = "The cors of the bucket"
  type = object({
    origin          = optional(list(string), ["*"])
    method          = optional(list(string), ["GET", "OPTIONS", "POST"])
    response_header = optional(list(string), ["*"])
    max_age_seconds = optional(number, 3600)
  })
  default = null
}

variable "bucket_public" {
  description = "Make bucket public"
  type        = bool
  default     = true
}

variable "load_balancing_scheme" {
  type        = string
  description = "Load balancing scheme"
  default     = "EXTERNAL"
}

##############
### LB-CDN ###
##############
variable "enable_lb" {
  type        = bool
  description = "Enable LB"
  default     = false
}

variable "target_http_proxy_name" {
  type        = string
  description = "Target HTTP proxy name"
}

variable "target_https_proxy_name" {
  type        = string
  description = "Target HTTPs proxy name"
}

variable "forwarding_rule_name" {
  type        = string
  description = "Forwarding rule name"
}

variable "forwarding_rule_name_https" {
  type        = string
  description = "Forwarding rule name for HTTPS"
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
    enable             = optional(bool, false)
    cache_mode         = optional(string, "CACHE_ALL_STATIC")
    client_ttl         = optional(number, 3600)
    default_ttl        = optional(number, 3600)
    max_ttl            = optional(number, 86400)
    negative_caching   = optional(bool, true)
    serve_while_stale  = optional(number, 86400)
    request_coalescing = optional(bool, true)
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