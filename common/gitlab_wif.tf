#create gitlab module
module "gitlab_wif" {
    source  = "../modules/gitlab_wif"
    project = var.project_id
    region  = var.region
    gitlab_namespace_id = var.gitlab_wif.gitlab_namespace_id
    gitlab_sa_permissions = var.gitlab_wif.gitlab_sa_permissions
}

