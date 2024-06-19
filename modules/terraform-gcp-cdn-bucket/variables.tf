# Copyright (c) 2020 The DAML Authors. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

variable "name" {
  description = "Name prefix for all the resources"
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}
variable "labels" {
  description = "Labels to apply on all the resources"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "GCP project name"
}

variable "region" {
  description = "GCP region in which to create the resources"
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