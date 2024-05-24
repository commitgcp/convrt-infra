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

variable "network" {
  type        = string
  description = "Network to create Load Balancer"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork to create Load Balancer"
}

variable "lb_port" {
  type        = string
  description = "Load Balancer listening port"
  default     = "80"
}