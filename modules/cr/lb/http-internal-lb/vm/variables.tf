###############
### General ###
###############
variable "project" {
  description = "Project where VM will be provision"
  type        = string
}

variable "network" {
  description = "Network name where VM will be provision"
  type        = string
}

variable "region" {
  description = "Region where VM will be provision"
  type        = string
}

variable "zone" {
  description = "Zone where VM will be provision"
  type        = string
}

variable "subnet" {
  description = "Subnet name where VM instance will be provision"
  type        = string
}

##########
### VM ###
##########
variable "vm_name" {
  description = "VM name"
  default     = "vm-ilb"
}

variable "vm_type" {
  description = "VM instance type"
  default     = "f1-micro"
}