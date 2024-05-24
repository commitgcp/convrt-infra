###############
### General ###
###############
variable "project" {
  type    = string
}

variable "region" {
  type    = string
}

###############################
### Gitlab Workload Identity###
###############################
variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "gitlab_namespace_id" {
  type        = string
  description = "Namespace ID"
}

variable "gitlab_sa_permissions" {
  type       = list(string)
  description = <<EOF
  List of permissions to assign to the Gitlab Service Account.
  Format: ["project=>role", "project=>role", ...]
  Example: ["project1=>roles/iam.workloadIdentityUser", "project1=>roles/artifactregistry.writer", "project2=>roles/container.developer"]
  EOF
  default = [
    "convrt-common=>roles/iam.workloadIdentityUser",
    "convrt-common=>roles/artifactregistry.writer",
    "convrt-common=>roles/container.developer",
    ]
}