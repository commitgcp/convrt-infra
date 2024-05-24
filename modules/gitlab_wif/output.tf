output "GCP_WORKLOAD_IDENTITY_PROVIDER" {
  value = google_iam_workload_identity_pool_provider.gitlab-provider-jwt.name
}

output "GCP_SERVICE_ACCOUNT" {
  value = module.gitlab_account.email
}