resource "random_id" "random" {
  byte_length = 4
}

resource "google_iam_workload_identity_pool" "gitlab-pool" {
  provider                  = google-beta
  workload_identity_pool_id = "gitlab-pool-${random_id.random.hex}"
  project = var.project
}

resource "google_iam_workload_identity_pool_provider" "gitlab-provider-jwt" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.gitlab-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "gitlab-jwt-${random_id.random.hex}"
  project = var.project
  #attribute_condition                = "assertion.namespace_path.startsWith(\"${var.gitlab_namespace_path}\")"
  attribute_mapping = {
    "google.subject"           = "assertion.sub", # Required
    "attribute.aud"            = "assertion.aud",
    "attribute.project_path"   = "assertion.project_path",
    "attribute.project_id"     = "assertion.project_id",
    "attribute.namespace_id"   = "assertion.namespace_id",
    "attribute.namespace_path" = "assertion.namespace_path",
    "attribute.user_email"     = "assertion.user_email",
    "attribute.ref"            = "assertion.ref",
    "attribute.ref_type"       = "assertion.ref_type",
  }
  oidc {
    issuer_uri        = var.gitlab_url
    allowed_audiences = [var.gitlab_url]
  }
  depends_on = [ google_iam_workload_identity_pool.gitlab-pool ]
}

module "gitlab_account" {
  source     = "terraform-google-modules/service-accounts/google"
  project_id = var.project
  names      = ["gitlab-sa"]
  project_roles = var.gitlab_sa_permissions
  display_name = "Gitlab SA"
}

resource "google_service_account_iam_binding" "gitlab-runner-oidc" {
  service_account_id = "projects/${var.project}/serviceAccounts/${module.gitlab_account.email}"
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gitlab-pool.name}/attribute.namespace_id/${var.gitlab_namespace_id}"
  ]
  depends_on = [ google_iam_workload_identity_pool.gitlab-pool ]
}
