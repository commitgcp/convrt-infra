#create gitlab module
module "gitlab_wif" {
  source                = "../modules/gitlab_wif"
  project               = var.project_id
  region                = var.region
  gitlab_namespace_id   = var.gitlab_wif.gitlab_namespace_id
  gitlab_sa_permissions = var.gitlab_wif.gitlab_sa_permissions
}

output "GCP_WORKLOAD_IDENTITY_PROVIDER" {
  value = module.gitlab_wif.GCP_WORKLOAD_IDENTITY_PROVIDER
}

output "GCP_SERVICE_ACCOUNT" {
  value = module.gitlab_wif.GCP_SERVICE_ACCOUNT
}