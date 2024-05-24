#create gitlab module
module "gitlab_wif" {
    source  = "../modules/gitlab_wif"
    project = var.project_id
    region  = var.region
    #gitlab_url = var.gitlab_url
    gitlab_namespace_id = "67201378"
    gitlab_sa_permissions = [
    "convrt-common=>roles/iam.workloadIdentityUser",
    "convrt-common=>roles/artifactregistry.writer",
    "convrt-common=>roles/run.developer",
    ]
}